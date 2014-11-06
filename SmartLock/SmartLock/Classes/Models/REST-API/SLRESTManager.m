//
//  SLRESTManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLRESTManager.h"

@interface SLRESTManager ()
@end

@implementation SLRESTManager

#pragma mark - Singleton

+ (SLRESTManager *)sharedManager
{
	static SLRESTManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [SLRESTManager new];
				  });

	return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:BASE_URL_STRING];
        
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

#pragma mark - Authorization Header

- (BOOL)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password
{
    if (!username || !password || [username isEqualToString:@""] || [password isEqualToString:@""]) {
        [self clearAuthorizationHeader];
        return NO;
    }
    
    [self.operationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    return YES;
}

- (void)clearAuthorizationHeader
{
    self.operationManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
}

@end
