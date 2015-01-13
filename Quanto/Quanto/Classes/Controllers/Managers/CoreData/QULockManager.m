//
//  QULockManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 30.12.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "QULockManager.h"
#import "QUKeyManager.h"
#import "QURoomManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointLocks     = @"locks/";
static NSString *QUAPIEndpointLock      = @"locks/:lockID/";
static NSString *QUAPIEndpointLockOpen  = @"locks/:lockID/open/";
static NSString *QUAPIEndpointLockClose = @"locks/:lockID/close/";

@implementation QULockManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [QULock class];
}

+ (NSString *)entityIDKey
{
	return @"lockID";
}

+ (BOOL)shouldInvokeSimpleUpdate
{
	return NO;
}

+ (BOOL)checkToUpdateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	QULock *lock = entity;
	BOOL didUpdate = NO;

	if (![lock.status isEqualToString:JSON[@"status"]]) {
		lock.status = JSON[@"status"];
		didUpdate = YES;
	}

	/*
	   if (![lock.locationLat isEqualToNumber:JSON[@"location_lat"]]) {
	    lock.locationLat = JSON[@"location_lat"];
	    didUpdate = YES;
	   }

	   if (![lock.locationLon isEqualToNumber:JSON[@"location_lon"]]) {
	    lock.locationLon = JSON[@"location_lon"];
	    didUpdate = YES;
	   }*/

	//    lock.keys = [QUKeyManager fetchOrCreateEntitiesWithEntityIDs:JSON[@"keys"]];

	QURoom *room = [QURoomManager updateOrCreateEntityWithJSON:JSON[@"room"]];
	if (lock.room != room) {
		lock.room = room;
		didUpdate = YES;
	}

	// DLOG(@"Updated User Profile with JSON:%@\n%@", JSON, userProfile);

	if (didUpdate) {
		DLOG(@"Updated QULock %@", lock.lockID);
	}

	return didUpdate;
}

#pragma mark - REST-API

+ (void)openLock:(QULock *)lock withSuccessHandler:(void (^)(QULock *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointLockOpen stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.lockID stringValue]];

	DLOG(@"Open Lock %@", endpoint);

	[[PFRESTManager sharedManager].operationManager POST:endpoint
											  parameters:nil
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 DLOG(@"Success!");
		 QULock *lock = [self updateOrCreateEntityWithJSON:responseObject];
		 successHandler(lock);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)closeLock:(QULock *)lock withSuccessHandler:(void (^)(QULock *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointLockClose stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.lockID stringValue]];

	DLOG(@"Close Lock %@", endpoint);

	[[PFRESTManager sharedManager].operationManager POST:endpoint
											  parameters:nil
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 DLOG(@"Success!");
		 QULock *lock = [self updateOrCreateEntityWithJSON:responseObject];
		 successHandler(lock);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)synchronizeLockWithLockID:(NSNumber *)lockID successHandler:(void (^)(QULock *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointLock stringByReplacingOccurrencesOfString:@":lockID" withString:[lockID stringValue]];
	[super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllLocksWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointLocks successHandler:successHandler failureHandler:failureHandler];
}

@end
