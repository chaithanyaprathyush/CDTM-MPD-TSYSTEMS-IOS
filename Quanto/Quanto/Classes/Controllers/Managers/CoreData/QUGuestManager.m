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

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QUGuest class];

		self.entityLocalIDKey = @"guestID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QUGuest *guest = entity;

	if ([JSON hasNonNullStringForKey:@"avatar"]) {
		guest.avatarURL = JSON[@"avatar"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"email"]) {
		guest.email = JSON[@"email"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"fax"]) {
		guest.fax = JSON[@"fax"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"first_name"]) {
		guest.firstName = JSON[@"first_name"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"last_name"]) {
		guest.lastName = JSON[@"last_name"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"customer_level"]) {
		guest.level = JSON[@"customer_level"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"mobile"]) {
		guest.mobile = JSON[@"mobile"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"phone"]) {
		guest.phone = JSON[@"phone"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"salutation"]) {
		guest.salutation = JSON[@"salutation"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"username"]) {
		guest.username = JSON[@"username"];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
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
			  QUGuest *guest = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];
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
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:QUAPIEndpointGuestMe
											 successHandler:^(id fetchedRemoteEntity) {
		 [self sharedManager].currentGuest = fetchedRemoteEntity;
		 successHandler(fetchedRemoteEntity);
	 } failureHandler:failureHandler];
}

+ (void)synchronizeGuestWithGuestID:(NSNumber *)guestID successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointGuest stringByReplacingOccurrencesOfString:@":guestID" withString:[guestID stringValue]];
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

@end
