//
//  SLRESTManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLRESTManager.h"
#import "SLUserManager.h"
#import "SLLockManager.h"
#import "SLAccessLogEntryManager.h"
#import "SLUserProfileManager.h"

@implementation SLRESTManager

#pragma mark - Singleton

+ (SLRESTManager *)sharedManager
{
	static SLRESTManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [SLRESTManager new];
					  [sharedManager initMappings];
				  });

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL_STRING]];

		self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
		self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;

		// set log levels
		RKLogConfigureByName("RestKit", RKLogLevelWarning);
		RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelWarning);
		RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
	}

	return self;
}

- (void)initMappings
{
    [self.objectManager addRequestDescriptorsFromArray:[SLUserManager sharedManager].requestDescriptors];
    [self.objectManager addResponseDescriptorsFromArray:[SLUserManager sharedManager].responseDescriptors];
    
    [self.objectManager addRequestDescriptorsFromArray:[SLLockManager sharedManager].requestDescriptors];
    [self.objectManager addResponseDescriptorsFromArray:[SLLockManager sharedManager].responseDescriptors];
    
    [self.objectManager addRequestDescriptorsFromArray:[SLAccessLogEntryManager sharedManager].requestDescriptors];
    [self.objectManager addResponseDescriptorsFromArray:[SLAccessLogEntryManager sharedManager].responseDescriptors];
    
    [self.objectManager addRequestDescriptorsFromArray:[SLUserProfileManager sharedManager].requestDescriptors];
    [self.objectManager addResponseDescriptorsFromArray:[SLUserProfileManager sharedManager].responseDescriptors];
}

- (BOOL)updateAuthorizationHeaderForUser:(SLUser *)user
{
	//NSLog(@"update auth header: %@", user);
	if (!user || !user.username || !user.password || [user.username isEqualToString:@""] || [user.password isEqualToString:@""]) {
		[self.objectManager.HTTPClient clearAuthorizationHeader];
        return NO;
	} else {
		[self.objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.username password:user.password];
        return YES;
	}
}

@end
