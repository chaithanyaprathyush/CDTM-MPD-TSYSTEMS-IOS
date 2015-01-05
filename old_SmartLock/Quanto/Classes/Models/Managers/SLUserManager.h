//
//  SLUserManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLUser.h"
#import "SLEntityManager.h"

@interface SLUserManager : SLEntityManager

+ (SLUserManager *)sharedManager;

@property(strong, nonatomic) SLUser *currentUser;

#pragma mark - Login / Logout

+ (NSString *)storedUsername;
+ (NSString *)storedPassword;

//- (void)registerUserWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSError *error, LMUser *user))completionHandler;
+ (void)logInWithStoredCredentialsWithCompletionHandler:(void(^)(NSError *error, SLUser *user))completionHandler;
+ (void)logInWithUsername:(NSString *)username password:(NSString *)password storeCredentialsOnSuccess:(BOOL)storeCredentialsOnSuccess completionHandler:(void (^)(NSError *error, SLUser *user))completionHandler;

+ (BOOL)isCurrentUserLoggedIn;

+ (void)logOutCurrentUser;

#pragma mark - CoreData & REST-API


@end
