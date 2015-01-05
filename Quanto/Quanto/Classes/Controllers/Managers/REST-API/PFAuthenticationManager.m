//
//  PFAuthenticationManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 11.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFAuthenticationManager.h"
#import "PFRESTManager.h"
#import "QUGuestManager.h"
#import "QUBluetoothManager.h"

static NSString *PFAuthenticationManagerDefaultsLoginCredentialsUsername    = @"AUTH_CREDENTIALS_USERNAME";
static NSString *PFAuthenticationManagerDefaultsLoginCredentialsPassword    = @"AUTH_CREDENTIALS_PASSWORD";
static NSString *PFAuthenticationManagerDefaultsLoginCredentialsAuthToken   = @"AUTH_CREDENTIALS_AUTH_TOKEN";

static NSString *QUAPIEndpointAuthenticationTokens = @"auth-tokens/";

typedef enum {
	PFAuthenticationTypeBasic,
	PFAuthenticationTypeToken
} PFAuthenticationType;

@implementation PFAuthenticationManager

static PFAuthenticationType authenticationType = PFAuthenticationTypeToken;

#pragma mark - Authentication

#pragma mark Basic Authentication

+ (void)authenticateWithUsername:(NSString *)username password:(NSString *)password storeCredentialsOnSuccess:(BOOL)storeCredentialsOnSuccess successHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Authenticating with username '%@', password '%@', auth-type: %i", username, password, authenticationType);

	if (authenticationType == PFAuthenticationTypeBasic) {
		[self setAuthenticationHeaderWithUsername:username password:password];

		[QUGuestManager synchronizeGuestWithSuccessHandler:^(QUGuest *guest) { // TODO: Replace this with check against some auth api endpoint whether user+password combo is okay instead of synching guest here (and later in the login view again
			 [QUGuestManager sharedManager].currentGuest = guest;

			 if (storeCredentialsOnSuccess) {
				 [self setStoredUsername:username];
				 [self setStoredPassword:password];
			 }

			 successHandler();
		 } failureHandler:^(NSError *error) {
			 failureHandler(error);
		 }];
	} else if (authenticationType == PFAuthenticationTypeToken) {
		if ([self storedAuthenticationToken]) {

			[self setAuthenticationHeaderWithAuthentictationToken:[self storedAuthenticationToken]];

			[QUBluetoothManager setAuthenticationToken:[self storedAuthenticationToken]];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[QUBluetoothManager startAdvertisingServices];
			});

			successHandler();
		} else {
			// 1. Make POST Request to Authentication endpoint to obtain Token
			[[PFRESTManager sharedManager].operationManager POST:QUAPIEndpointAuthenticationTokens
													  parameters:@{@"username":username, @"password":password}
														 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			     // 2. Set auth token
				 NSString *authenticationToken = responseObject[@"token"];
				 DLOG(@"Success: obtained authenticationToken: %@", authenticationToken);

				 [self setAuthenticationHeaderWithAuthentictationToken:authenticationToken];
				 [QUBluetoothManager setAuthenticationToken:authenticationToken];

				 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[QUBluetoothManager startAdvertisingServices];
                 });

				 if (storeCredentialsOnSuccess) {
					 [self setStoredUsername:username];
					 [self setStoredPassword:password];
					 [self setStoredAuthenticationToken:authenticationToken];
				 }

				 successHandler();
			 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				 DLOG(@"Failure: %@", error);

				 failureHandler(error);
			 }];
		}
	}
}

#pragma mark - Authentication Header Utils
#pragma mark Common

+ (void)clearAuthenticationHeader
{
	[[PFRESTManager sharedManager].operationManager.requestSerializer clearAuthorizationHeader];
	[QUBluetoothManager setAuthenticationToken:nil];
	[QUBluetoothManager stopAdvertisingServices];
}

#pragma mark Basic Authentication

+ (BOOL)setAuthenticationHeaderWithUsername:(NSString *)username password:(NSString *)password
{
	AFHTTPRequestSerializer *requestSerializer = [PFRESTManager sharedManager].operationManager.requestSerializer;

	if (!username || [username isEqualToString:@""] || !password || [password isEqualToString:@""]) {
		DLOG(@"WARNING: username '%@' & password '%@' are not okay!", username, password);

		[requestSerializer clearAuthorizationHeader];
		return NO;
	}

	[requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];

	DLOG(@"Did set authorization header with username '%@' and password '%@'", username, password);

	return YES;
}

#pragma mark Token Authentication

+ (BOOL)setAuthenticationHeaderWithAuthentictationToken:(NSString *)authenticationToken
{
	AFHTTPRequestSerializer *requestSerializer = [PFRESTManager sharedManager].operationManager.requestSerializer;

	if (!authenticationToken || [authenticationToken isEqualToString:@""]) {
		DLOG(@"WARNING: authenticationToken '%@' is invalid!", authenticationToken);

		[requestSerializer clearAuthorizationHeader];
		return NO;
	}

	[requestSerializer setValue:[NSString stringWithFormat:@"Token %@", authenticationToken] forHTTPHeaderField:@"Authorization"];

	DLOG(@"Did set authorization header with 'Token %@'", authenticationToken);

	return YES;
}

#pragma mark Stored

+ (void)authenticateWithStoredCredentialsWithSuccessHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Authenticate with stored credentials");

	if ([self hasStoredCredentials]) {
		[self authenticateWithUsername:[self storedUsername]
							  password:[self storedPassword]
			 storeCredentialsOnSuccess:YES
						successHandler:successHandler
						failureHandler:failureHandler];
	} else {
		failureHandler([NSError errorWithDomain:@"de.cdtm.quanto.ios"
										   code:0
									   userInfo:@{@"message":@"No stored credentials!"}]);
	}
}

+ (BOOL)hasStoredCredentials
{
	switch (authenticationType) {
	case PFAuthenticationTypeBasic:
	{
		NSString *storedUsername = [self storedUsername];
		NSString *storedPassword = [self storedPassword];

		return storedUsername && ![storedUsername isEqualToString:@""] && storedPassword && ![storedPassword isEqualToString:@""];
	}
	case PFAuthenticationTypeToken:
	{
		NSString *storedAuthenticationToken = [self storedAuthenticationToken];

		return storedAuthenticationToken && ![storedAuthenticationToken isEqualToString:@""];
	}
	default:
		return NO;
	}
}

#pragma mark - Stored Authentication Credentials
#pragma mark Common

+ (void)resetStoredCredentials
{
	[self resetStoredUsername];
	[self resetStoredPassword];
	[self resetStoredAuthenticationToken];

	[self clearAuthenticationHeader];
}

+ (void)setUserDefaultsObject:(id)object forKey:(NSString *)key
{
	if (key && ![key isEqualToString:@""]) {
		if (object) {
			[[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
		} else {
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
		}
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (id)userDefaultsObjectForKey:(NSString *)key
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark Username

+ (void)setStoredUsername:(NSString *)storedUsername
{
	[self setUserDefaultsObject:storedUsername forKey:PFAuthenticationManagerDefaultsLoginCredentialsUsername];
}

+ (void)resetStoredUsername
{
	[self setStoredUsername:nil];
}

+ (NSString *)storedUsername
{
	return [self userDefaultsObjectForKey:PFAuthenticationManagerDefaultsLoginCredentialsUsername];
}

#pragma mark Password

+ (void)setStoredPassword:(NSString *)storedPassword
{
	[self setUserDefaultsObject:storedPassword forKey:PFAuthenticationManagerDefaultsLoginCredentialsPassword];
}

+ (void)resetStoredPassword
{
	[self setStoredPassword:nil];
}

+ (NSString *)storedPassword
{
	return [self userDefaultsObjectForKey:PFAuthenticationManagerDefaultsLoginCredentialsPassword];
}

#pragma mark AuthenticationToken

+ (void)setStoredAuthenticationToken:(NSString *)authenticationToken
{
	[self setUserDefaultsObject:authenticationToken forKey:PFAuthenticationManagerDefaultsLoginCredentialsAuthToken];
}

+ (void)resetStoredAuthenticationToken
{
	[self setStoredAuthenticationToken:nil];
}

+ (NSString *)storedAuthenticationToken
{
	return [self userDefaultsObjectForKey:PFAuthenticationManagerDefaultsLoginCredentialsAuthToken];
}

@end
