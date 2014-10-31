//
//  SLLockManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLockManager.h"
#import <RestKit/RestKit.h>
#import "SLRESTManager.h"

static NSString *SLAPIEndpointLocks     = @"locks/";
static NSString *SLAPIEndpointLocksMy   = @"locks/my/";
static NSString *SLAPIEndpointLock      = @"locks/:lockID/";
static NSString *SLAPIEndpointLockOpen  = @"locks/:lockID/open/";
static NSString *SLAPIEndpointLockClose = @"locks/:lockID/close/";

@implementation SLLockManager

#pragma mark - Singleton

+ (SLLockManager *)sharedManager
{
	static SLLockManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [SLLockManager new];
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
	RKObjectMapping *lockMapping = [RKObjectMapping mappingForClass:[SLLock class]];
	[lockMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"identifier",
		 @"name" : @"name",
		 @"key" : @"key",
		 @"status" : @"status"
	 }];

	[self.responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																					 method:RKRequestMethodGET
																				pathPattern:SLAPIEndpointLocks
																					keyPath:@"results"
																				statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[self.responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																					 method:RKRequestMethodGET
																				pathPattern:SLAPIEndpointLocksMy
																					keyPath:@"results"
																				statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[self.responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																					 method:RKRequestMethodGET
																				pathPattern:SLAPIEndpointLock
																					keyPath:nil
																				statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[self.responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																					 method:RKRequestMethodPOST
																				pathPattern:SLAPIEndpointLockOpen
																					keyPath:@"results"
																				statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[self.responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																					 method:RKRequestMethodPOST
																				pathPattern:SLAPIEndpointLockClose
																					keyPath:@"results"
																				statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

- (void)fetchAllLocksWithCompletionHandler:(void (^)(NSError *error, NSArray *locks))completionHandler
{
	[[SLRESTManager sharedManager].objectManager getObjectsAtPath:SLAPIEndpointLocks
													   parameters:nil
														  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.array);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

- (void)fetchMyLocksWithCompletionHandler:(void (^)(NSError *error, NSArray *locks))completionHandler
{
	[[SLRESTManager sharedManager].objectManager getObjectsAtPath:SLAPIEndpointLocksMy
													   parameters:nil
														  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.array);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

- (void)fetchLockWithIdentifier:(NSNumber *)identifier completionHandler:(void (^)(NSError *, SLLock *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointLock stringByReplacingOccurrencesOfString:@":lockID" withString:[identifier stringValue]];

	[[SLRESTManager sharedManager].objectManager getObject:nil
													  path:endpoint
												parameters:nil
												   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.firstObject);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

- (void)openLock:(SLLock *)lock withCompletionHandler:(void (^)(NSError *, SLLock *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointLockOpen stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.identifier stringValue]];

	[[SLRESTManager sharedManager].objectManager postObject:nil
													   path:endpoint
												 parameters:nil
													success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.firstObject);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

- (void)closeLock:(SLLock *)lock withCompletionHandler:(void (^)(NSError *, SLLock *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointLockClose stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.identifier stringValue]];

	[[SLRESTManager sharedManager].objectManager postObject:nil
													   path:endpoint
												 parameters:nil
													success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.firstObject);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

@end
