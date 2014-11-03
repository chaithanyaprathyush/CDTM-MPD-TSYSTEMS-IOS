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
	// TODO: CHANGE BACKEND FOR THIS
	[[SLRESTManager sharedManager].objectManager getObjectsAtPath:SLAPIEndpointLocks
													   parameters:nil
														  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.array);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

- (void)fetchLockWithLockID:(NSNumber *)lockID completionHandler:(void (^)(NSError *, SLLock *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointLock stringByReplacingOccurrencesOfString:@":lockID" withString:[lockID stringValue]];

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
	NSString *endpoint = [SLAPIEndpointLockOpen stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.lockID stringValue]];

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
	NSString *endpoint = [SLAPIEndpointLockClose stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.lockID stringValue]];

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
