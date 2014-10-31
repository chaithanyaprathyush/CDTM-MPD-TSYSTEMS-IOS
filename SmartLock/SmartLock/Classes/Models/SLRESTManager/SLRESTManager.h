//
//  SLRESTManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>
#import "SLUser.h"

static NSString *BASE_URL_STRING = YES ? @"http://127.0.0.1:8000/api/" : @"http://213.165.86.29:8000/api/";

@interface SLRESTManager : NSObject

+ (SLRESTManager *)sharedManager;

@property (nonatomic, retain) RKObjectManager *objectManager;

// returns YES if RESTManager is able to make requests with the provider user
- (BOOL)updateAuthorizationHeaderForUser:(SLUser *)user;

@end
