//
//  SLUserManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLUser+SLRESTAPI.h"

@interface SLUserManager : NSObject

+ (SLUserManager *)sharedManager;

@property(strong, nonatomic) SLUser *currentUser;

#pragma mark - Utils

- (BOOL)isCurrentUserLoggedIn;

- (BOOL)hasStoredCredentials;
@property (nonatomic, retain) NSString *storedUsername;
@property (nonatomic, retain) NSString *storedPassword;

- (void)logOutCurrentUser;

#pragma mark - REST API

- (void)initRequestAndResponseDescriptorsForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;

//- (void)registerUserWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSError *error, SLUser *user))completionHandler;
- (void)logInWithStoredCredentialsWithCompletionHandler:(void(^)(NSError *error, SLUser *user))completionHandler;
- (void)logInWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void (^)(NSError *error, SLUser *user))completionHandler;

@end
