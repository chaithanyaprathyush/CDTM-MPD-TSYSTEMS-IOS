//
//  PFRESTManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFRESTManager.h"

#if TARGET_IPHONE_SIMULATOR
static NSString *HOST_AND_PORT = YES ? @"http://127.0.0.1:8000" : @"http://cdtmmpd.de";
#else
static NSString *HOST_AND_PORT = YES ? @"http://192.168.0.100:8000" : @"http://cdtmmpd.de";
#endif

@implementation PFRESTManager

#pragma mark - Singleton

+ (PFRESTManager *)sharedManager
{
	static PFRESTManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [PFRESTManager new];
				  });

	return sharedManager;
}

+ (NSString *)hostAndPortURLAsString
{
    return HOST_AND_PORT;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		NSURL *baseURL = [NSURL URLWithString:[HOST_AND_PORT stringByAppendingString:@"/api/"]];

		self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
		self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        DLOG(@"Initialized PFRESTManager with base URL '%@'", baseURL);
	}

	return self;
}

@end
