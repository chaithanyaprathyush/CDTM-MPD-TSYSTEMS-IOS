//
//  QUGuestManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 30.12.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "QUGuestManager.h"
#import "PFAuthenticationManager.h"
#import "QUBluetoothManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointGuests    = @"guests/";
static NSString *QUAPIEndpointGuest     = @"guests/:guestID/";
static NSString *QUAPIEndpointGuestMe   = @"guests/my/";

@implementation QUGuestManager

#pragma mark - Singleton

+ (QUGuestManager *)sharedManager
{
	static QUGuestManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUGuestManager new];
	});

	return sharedManager;
}

#pragma mark - Utils

+ (QUGuest *)currentGuest
{
    return [self sharedManager].currentGuest;
}

- (void)setCurrentGuest:(QUGuest *)currentGuest
{
    if (currentGuest) {
        _currentGuest = currentGuest;
    }
}

+ (BOOL)isCurrentGuestLoggedIn
{
	return [QUGuestManager sharedManager].currentGuest != nil;
}

+ (void)logOutCurrentGuest
{
	[QUGuestManager sharedManager].currentGuest = nil;
}

#pragma mark - CoreData

+ (Class)entityClass
{
	return [QUGuest class];
}

+ (NSString *)entityIDKey
{
	return @"guestID";
}

+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	QUGuest *guest = entity;
    
    if ([JSON hasNonNullStringForKey:@"avatar"]) {
        guest.avatarURL = JSON[@"avatar"];
    }
    
	guest.email = JSON[@"email"];
	guest.fax = JSON[@"fax"];
	guest.firstName = JSON[@"first_name"];
	guest.lastName = JSON[@"last_name"];
	guest.level = JSON[@"customer_level"];
	// keys
	guest.mobile = JSON[@"mobile"];
	guest.phone = JSON[@"phone"];
	guest.salutation = JSON[@"salutation"];
	// stays
	guest.username = JSON[@"username"];

	// DLOG(@"Updated QUGuest with JSON:%@\n%@", JSON, guest);
	DLOG(@"Updated QUGuest %@", guest.username);
}

#pragma mark - REST-API

+ (void)createGuestWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email firstName:(NSString *)firstName lastName:(NSString *)lastName successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSDictionary *parameters = @{@"username":username,
								 @"password":password,
								 @"email":email,
								 @"first_name":firstName,
								 @"last_name":lastName};

	DLOG(@"Create Guest with parameters: %@", parameters);

	// TODO: DUMMY ADMIN
	[PFAuthenticationManager authenticateWithUsername:@"quanto_iOS"
											 password:@"quanto_iOS_14"
							storeCredentialsOnSuccess:NO
									   successHandler:^{
		 [[PFRESTManager sharedManager].operationManager POST:QUAPIEndpointGuests
												   parameters:parameters
													  success:^(AFHTTPRequestOperation *operation, id responseObject) {
			  QUGuest *guest = [self updateOrCreateEntityWithJSON:responseObject];
			  DLOG(@"Successfully created new guest: %@", guest);
			  successHandler(guest);
		  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			  DLOG(@"Failure: %@", error);
			  failureHandler(error);
		  }];
	 } failureHandler:failureHandler];
}

+ (void)synchronizeGuestWithSuccessHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[super fetchSingleRemoteEntityAtEndpoint:QUAPIEndpointGuestMe
							  successHandler:^(id fetchedRemoteEntity) {
		 [self sharedManager].currentGuest = fetchedRemoteEntity;
		 successHandler(fetchedRemoteEntity);
	 } failureHandler:failureHandler];
}

+ (void)synchronizeGuestWithGuestID:(NSNumber *)guestID successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointGuest stringByReplacingOccurrencesOfString:@":guestID" withString:[guestID stringValue]];
	[super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

@end
