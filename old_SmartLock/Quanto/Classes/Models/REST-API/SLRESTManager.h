//
//  SLRESTManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#if TARGET_IPHONE_SIMULATOR
    static NSString *BASE_URL_STRING = YES ? @"http://127.0.0.1:8000/api/" : @"http://cdtmmpd.de/api/";
#else
    static NSString *BASE_URL_STRING = NO ? @"http://MacBook-Air.local:8000/api/" : @"http://cdtmmpd.de/api/";
#endif

static NSString *SLAPIEndpointUsers = @"users/";

static NSString *SLAPIEndpointUserProfiles  = @"user-profiles/";
static NSString *SLAPIEndpointUserProfile   = @"user-profiles/:userProfileID/";

static NSString *SLAPIEndpointLocks     = @"locks/";
static NSString *SLAPIEndpointLock      = @"locks/:lockID/";
static NSString *SLAPIEndpointLockOpen  = @"locks/:lockID/open/";
static NSString *SLAPIEndpointLockClose = @"locks/:lockID/close/";

static NSString *SLAPIEndpointAccessLogEntries  = @"access-log-entries/";
static NSString *SLAPIEndpointAccessLogEntry    = @"access-log-entries/:accessLogEntryID/";

@interface SLRESTManager : NSObject

+ (SLRESTManager *)sharedManager;

@property (nonatomic, retain) AFHTTPRequestOperationManager *operationManager;

- (BOOL)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password;
- (void)clearAuthorizationHeader;

@end
