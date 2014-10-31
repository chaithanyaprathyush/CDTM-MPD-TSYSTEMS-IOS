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

static NSString *SLAPIEndpointAccessLogEntries  = @"access-log-entries/";
static NSString *SLAPIEndpointAccessLogEntry    = @"access-log-entries/:ID/";

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

- (instancetype)init
{
	if (self = [super init]) {
		[self initRequestAndResponseDescriptors];
	}
	return self;
}

- (void)initRequestAndResponseDescriptors
{
	self.requestDescriptors = [NSMutableArray array];
	self.responseDescriptors = [NSMutableArray array];

	// Mapping
	RKObjectMapping *accessLogEntryMapping = [RKObjectMapping mappingForClass:[SLAccessLogEntry class]];
	[accessLogEntryMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"identifier",
		 @"user" : @"userIdentifier",
		 @"lock" : @"lockIdentifier",
		 @"key" : @"keyIdentifier",
         @"action" : @"action",
         @"date_created" : @"createdAt"
	 }];

	[self.responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:accessLogEntryMapping
																					 method:RKRequestMethodGET
																				pathPattern:SLAPIEndpointAccessLogEntries
																					keyPath:@"results"
																				statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[self.responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:accessLogEntryMapping
																					 method:RKRequestMethodGET
																				pathPattern:SLAPIEndpointAccessLogEntry
																					keyPath:@"results"
																				statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
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
