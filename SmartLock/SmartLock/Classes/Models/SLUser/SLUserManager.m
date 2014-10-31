//
//  SLUserManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUserManager.h"
#import "SLRESTManager.h"

static NSString *SLUserDefaultsLoginCredentialsUsername = @"LOGIN_CREDENTIALS_USERNAME";
static NSString *SLUserDefaultsLoginCredentialsPassword = @"LOGIN_CREDENTIALS_PASSWORD";

static NSString *SLAPIEndpointUsers = @"users/";

@implementation SLUserManager

#pragma mark - Singleton

+ (SLUserManager *)sharedManager
{
	static SLUserManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [SLUserManager new];
				  });

	return sharedManager;
}

- (instancetype)init
{
	if (self = [super init]) {
		[self initRequestAndResponseDescriptors];
	}
	return self;
}

- (void)initRequestAndResponseDescriptors
{
	self.requestDescriptors = [NSMutableArray array];
	self.responseDescriptors = [NSMutableArray array];

	// Mapping
	RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[SLUser class]];
	[userMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"identifier",
		 @"email" : @"email",
		 @"username" : @"username",
		 @"first_name" : @"firstName",
		 @"last_name" : @"lastName",
		 @"date_joined" : @"joinedAt",
		 @"password" : @"password"
	 }];

	[self.responseDescriptors addObject:
	 [RKResponseDescriptor responseDescriptorWithMapping:userMapping
												  method:RKRequestMethodGET
											 pathPattern:SLAPIEndpointUsers
												 keyPath:@"results"
											 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

#pragma mark - Utils

- (void)updateStoredLoginCredentialsForUser:(SLUser *)user
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	if (user) {
		[defaults setObject:user.username forKey:SLUserDefaultsLoginCredentialsUsername];
		[defaults setObject:user.password forKey:SLUserDefaultsLoginCredentialsPassword];
	} else {
		[defaults removeObjectForKey:SLUserDefaultsLoginCredentialsUsername];
		[defaults removeObjectForKey:SLUserDefaultsLoginCredentialsPassword];
	}

	[defaults synchronize];
}

- (BOOL)isCurrentUserLoggedIn
{
	return self.currentUser != nil;
}

- (void)logOutCurrentUser
{
	self.currentUser = nil;

	[self updateStoredLoginCredentialsForUser:nil];

	[[SLRESTManager sharedManager] updateAuthorizationHeaderForUser:nil];
}

- (BOOL)hasStoredCredentials
{
    NSString *storedUsername = self.storedUsername;
	NSString *storedPassword = self.storedPassword;

	return storedUsername && ![storedUsername isEqualToString:@""] && storedPassword && ![storedPassword isEqualToString:@""];
}

- (NSString *)storedUsername
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SLUserDefaultsLoginCredentialsUsername];
}

- (NSString *)storedPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SLUserDefaultsLoginCredentialsPassword];
}

- (void)setStoredPassword:(NSString *)storedPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:storedPassword forKey:SLUserDefaultsLoginCredentialsPassword];
}

- (void)setStoredUsername:(NSString *)storedUsername
{
    [[NSUserDefaults standardUserDefaults] setObject:storedUsername forKey:SLUserDefaultsLoginCredentialsUsername];
}

#pragma mark - REST API

- (void)logInWithStoredCredentialsWithCompletionHandler:(void (^)(NSError *error, SLUser *user))completionHandler
{
    NSString *storedUsername = self.storedUsername;
    NSString *storedPassword = self.storedPassword;

	if (storedUsername && ![storedUsername isEqualToString:@""] && storedPassword && ![storedPassword isEqualToString:@""]) {
		[self logInWithUsername:storedUsername password:storedPassword completionHandler:^(NSError *error, SLUser *user) {
			 if (!error) {
				 self.currentUser = user;
			 }

			 completionHandler(error, user);
		 }];
	} else {
		NSError *error = [NSError errorWithDomain:@"com.donoapp.ios.usermanager" code:010 userInfo:@{@"info":@"Username/Password were not provided."}];
		completionHandler(error, nil);
	}
}

- (void)logInWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void (^)(NSError *error, SLUser *user))completionHandler
{
	SLUser *user = [SLUser new];
	user.username = username;
	user.password = password;

	[[SLRESTManager sharedManager] updateAuthorizationHeaderForUser:user];

	[[SLRESTManager sharedManager].objectManager getObjectsAtPath:SLAPIEndpointUsers
													   parameters:nil
														  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 self.currentUser = mappingResult.firstObject;
		 self.currentUser.password = password;
                                                              
		 [self updateStoredLoginCredentialsForUser:user];

		 completionHandler(nil, user);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
	     // NSLog(@"fail: %@", error);
		 completionHandler(error, nil);
	 }];
}

/*
 - (void)registerUserWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSError *error, SLUser *user))completionHandler
 {
 SLUser *requestUser = [SLUser new];
 requestUser.email = email;
 requestUser.password = password;
 
 [[RESTManager sharedManager].objectManager postObject:requestUser
 path:API_USERS_REGISTER
 parameters:nil
 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
 User *responseUser = mappingResult.firstObject;
 responseUser.password = password;
 
 [self updateStoredLoginCredentialsForUser:responseUser];
 [[RESTManager sharedManager] updateAuthorizationHeaderForUser:responseUser];
 
 completionHandler(nil, responseUser);
 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
 // NSLog(@"fail: %@", error);
 completionHandler(error, nil);
 }];
 }*/

@end
