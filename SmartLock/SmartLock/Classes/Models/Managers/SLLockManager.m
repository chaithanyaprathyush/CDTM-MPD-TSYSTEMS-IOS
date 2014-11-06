//
//  SLLockManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLockManager.h"
#import "SLRESTManager.h"
#import "NSDictionary+SLUtils.h"

@implementation SLLockManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [SLLock class];
}

+ (NSString *)entityIDKey
{
	return @"lockID";
}

+ (SLLock *)updateOrCreateEntityWithJSON:(NSDictionary *)JSON
{
	NSNumber *lockID = JSON[@"id"];

	SLLock *lock = [self fetchOrCreateEntityWithEntityID:lockID];

	lock.name = JSON[@"name"];
	lock.status = JSON[@"status"];
	lock.locationLat = JSON[@"location_lat"];
	lock.locationLon = JSON[@"location_lon"];
	lock.createdAt = [JSON dateForKey:@"date_created"];
	lock.lastModifiedAt = [JSON dateForKey:@"last_modified"];

//    lock.keys = TODO
	// TODO: FETCH KEYS FOR LOG!

	[[SLCoreDataManager sharedManager] save];

	return lock;
}

#pragma mark - REST-API

+ (void)synchronizeLockWithLockID:(NSNumber *)lockID completionHandler:(void (^)(NSError *, SLLock *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointLock stringByReplacingOccurrencesOfString:@":lockID" withString:[lockID stringValue]];

	[[SLRESTManager sharedManager].operationManager GET:endpoint
											 parameters:nil
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 SLLock *lock = [self updateOrCreateEntityWithJSON:responseObject];
		 completionHandler(nil, lock);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 NSLog(@"error: %@", error);
		 completionHandler(error, nil);
	 }];
}

+ (void)synchronizeAllLocksWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
	[[SLRESTManager sharedManager].operationManager GET:SLAPIEndpointLocks
											 parameters:nil
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 NSArray *locks = [self updateOrCreateEntitiesWithJSON:responseObject[@"results"]];
		 completionHandler(nil, locks);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

+ (void)openLock:(SLLock *)lock withCompletionHandler:(void (^)(NSError *, SLLock *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointLockOpen stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.lockID stringValue]];

	[[SLRESTManager sharedManager].operationManager POST:endpoint
											  parameters:nil
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 SLLock *lock = [self updateOrCreateEntityWithJSON:responseObject];
		 completionHandler(nil, lock);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

+ (void)closeLock:(SLLock *)lock withCompletionHandler:(void (^)(NSError *, SLLock *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointLockClose stringByReplacingOccurrencesOfString:@":lockID" withString:[lock.lockID stringValue]];

	[[SLRESTManager sharedManager].operationManager POST:endpoint
											  parameters:nil
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 SLLock *lock = [self updateOrCreateEntityWithJSON:responseObject];
		 completionHandler(nil, lock);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

@end
