//
//  SLUserManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUserManager.h"
#import "SLRESTManager.h"
#import <CoreData/CoreData.h>
#import "NSDictionary+SLUtils.h"
#import "SLUserProfileManager.h"

static NSString *SLUserDefaultsLoginCredentialsUsername = @"LOGIN_CREDENTIALS_USERNAME";
static NSString *SLUserDefaultsLoginCredentialsPassword = @"LOGIN_CREDENTIALS_PASSWORD";

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

#pragma mark - Utils

+ (void)updateStoredUsername:(NSString *)username password:(NSString *)password
{
	if (username && ![username isEqualToString:@""] && password && ![password isEqualToString:@""]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

		[defaults setObject:username forKey:SLUserDefaultsLoginCredentialsUsername];
		[defaults setObject:password forKey:SLUserDefaultsLoginCredentialsPassword];

		[defaults synchronize];
	} else {
		[SLUserManager resetStoredUsernameAndPassword];
	}
}

+ (void)resetStoredUsernameAndPassword
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults removeObjectForKey:SLUserDefaultsLoginCredentialsUsername];
	[defaults removeObjectForKey:SLUserDefaultsLoginCredentialsPassword];

	[defaults synchronize];
}

+ (BOOL)isCurrentUserLoggedIn
{
	return [SLUserManager sharedManager].currentUser != nil;
}

+ (void)logOutCurrentUser
{
	[SLUserManager sharedManager].currentUser = nil;

	[SLUserManager resetStoredUsernameAndPassword];

	[[SLRESTManager sharedManager] clearAuthorizationHeader];
}

+ (BOOL)hasStoredCredentials
{
	NSString *storedUsername = [SLUserManager storedUsername];
	NSString *storedPassword = [SLUserManager storedPassword];

	return storedUsername && ![storedUsername isEqualToString:@""] && storedPassword && ![storedPassword isEqualToString:@""];
}

+ (NSString *)storedUsername
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:SLUserDefaultsLoginCredentialsUsername];
}

+ (NSString *)storedPassword
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:SLUserDefaultsLoginCredentialsPassword];
}

+ (void)setStoredUsername:(NSString *)storedUsername
{
	[[NSUserDefaults standardUserDefaults] setObject:storedUsername forKey:SLUserDefaultsLoginCredentialsUsername];
}

+ (void)setStoredPassword:(NSString *)storedPassword
{
	[[NSUserDefaults standardUserDefaults] setObject:storedPassword forKey:SLUserDefaultsLoginCredentialsPassword];
}

#pragma mark - REST API

+ (void)logInWithStoredCredentialsWithCompletionHandler:(void (^)(NSError *error, SLUser *user))completionHandler
{
	NSString *storedUsername = self.storedUsername;
	NSString *storedPassword = self.storedPassword;

	if (storedUsername && ![storedUsername isEqualToString:@""] && storedPassword && ![storedPassword isEqualToString:@""]) {
		[SLUserManager logInWithUsername:storedUsername password:storedPassword storeCredentialsOnSuccess:YES completionHandler:completionHandler];
	} else {
		NSError *error = [NSError errorWithDomain:@"de.cdtm.mpd14.ios.usermanager" code:010 userInfo:@{@"info":@"Username/Password were not provided."}];
		completionHandler(error, nil);
	}
}

+ (void)logInWithUsername:(NSString *)username password:(NSString *)password storeCredentialsOnSuccess:(BOOL)storeCredentialsOnSuccess completionHandler:(void (^)(NSError *, SLUser *))completionHandler
{
	[[SLRESTManager sharedManager] setAuthorizationHeaderWithUsername:username password:password];

	[[SLRESTManager sharedManager].operationManager GET:SLAPIEndpointUsers
											 parameters:nil
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 NSArray *users = [SLUserManager updateOrCreateEntitiesWithJSON:responseObject[@"results"]];

		 SLUser *user = users.firstObject;

		 if (user) {
			 [SLUserManager sharedManager].currentUser = user;

			 if (storeCredentialsOnSuccess) {
				 [self updateStoredUsername:username password:password];
			 }

	         // In addition, load the user's profile
			 [SLUserProfileManager synchronizeUserProfileWithUserProfileID:user.userProfile.userProfileID completionHandler:^(NSError *error, SLUserProfile *userProfile) {
				  completionHandler(nil, user);
			  }];
		 } else {
			 completionHandler([NSError errorWithDomain:@"de.cdtmmpd.api.user-profiles" code:1 userInfo:@{@"Message" : @"Wrong credentials!"}], nil);
		 }


	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

#pragma mark - CoreData

+ (Class)entityClass
{
	return [SLUser class];
}

+ (NSString *)entityIDKey
{
	return @"userID";
}

+ (id)updateOrCreateEntityWithJSON:(NSDictionary *)JSON
{
	NSNumber *userID = JSON[@"id"];

	SLUser *user = [SLUserManager fetchOrCreateEntityWithEntityID:userID];

	user.email = JSON[@"email"];
	user.firstName = JSON[@"first_name"];

	user.joinedAt = [JSON dateForKey:@"date_joined"];
	user.lastName = JSON[@"last_name"];
	user.userID = JSON[@"id"];
	user.username = JSON[@"username"];

	NSNumber *userProfileID = JSON[@"user_profile"];
	if (userProfileID) {
		user.userProfile = [SLUserProfileManager fetchOrCreateEntityWithEntityID:userProfileID];
	}
	//    user.loyaltyCards
	//    user.businessPartners

	[[SLCoreDataManager sharedManager] save];

	return user;
}

@end