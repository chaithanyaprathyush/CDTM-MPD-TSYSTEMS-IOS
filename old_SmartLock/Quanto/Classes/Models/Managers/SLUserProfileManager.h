//
//  SLUserProfileManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLUserProfile.h"
#import "SLEntityManager.h"

@interface SLUserProfileManager : SLEntityManager

+ (void)synchronizeUserProfileWithUserProfileID:(NSNumber *)userProfileID completionHandler:(void (^)(NSError *, SLUserProfile *))completionHandler;
+ (void)synchronizeAllUserProfilesWithCompletionHandler:(void (^)(NSError *, NSArray *userProfiles))completionHandler;

@end
