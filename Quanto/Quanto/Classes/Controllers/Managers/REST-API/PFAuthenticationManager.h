//
//  PFAuthenticationManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 11.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFAuthenticationManager : NSObject

#pragma mark - Authentication
+ (void)authenticateWithUsername:(NSString *)username password:(NSString *)password storeCredentialsOnSuccess:(BOOL)storeCredentialsOnSuccess successHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler;
+ (void)authenticateWithStoredCredentialsWithSuccessHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler;

#pragma mark - Stored Authentication Credentials
#pragma mark Common
+ (BOOL)hasStoredCredentials;
+ (void)resetStoredCredentials;

#pragma mark Username
+ (void)setStoredUsername:(NSString *)storedUsername;
+ (void)resetStoredUsername;
+ (NSString *)storedUsername;

#pragma mark Password
+ (void)setStoredPassword:(NSString *)storedPassword;
+ (void)resetStoredPassword;
+ (NSString *)storedPassword;

#pragma mark AuthenticationToken
+ (void)setStoredAuthenticationToken:(NSString *)authenticationToken;
+ (void)resetStoredAuthenticationToken;
+ (NSString *)storedAuthenticationToken;

@end
