//
//  SLUserProfileManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLUserProfile.h"
#import "SLUser.h"

@interface SLUserProfileManager : NSObject

+ (SLUserProfileManager *)sharedManager;

@property (nonatomic, retain) NSMutableArray *responseDescriptors;
@property (nonatomic, retain) NSMutableArray *requestDescriptors;

- (void)fetchUserProfileForUserIdentifier:(NSNumber *)userIdentifier completionHandler:(void(^)(NSError *error, SLUserProfile *userProfile))completionHandler;

@end
