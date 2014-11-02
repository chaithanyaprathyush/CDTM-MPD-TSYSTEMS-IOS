//
//  SLAccessLogEntryManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLAccessLogEntryManager.h"
#import <RestKit/RestKit.h>
#import "SLRESTManager.h"

@implementation SLAccessLogEntryManager

#pragma mark - Singleton

+ (SLAccessLogEntryManager *)sharedManager
{
	static SLAccessLogEntryManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [SLAccessLogEntryManager new];
				  });

	return sharedManager;
}

- (void)fetchAllAccessLogEntriesWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
	[[SLRESTManager sharedManager].objectManager getObjectsAtPath:SLAPIEndpointAccessLogEntries
													   parameters:nil
														  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.array);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

@end
