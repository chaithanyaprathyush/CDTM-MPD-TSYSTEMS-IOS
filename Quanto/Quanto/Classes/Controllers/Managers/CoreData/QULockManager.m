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

#pragma mark - Singleton

+ (QULockManager *)sharedManager
{
	static QULockManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QULockManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QULock class];

		self.entityLocalIDKey = @"lockID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QULock *lock = entity;

	if ([JSON hasNonNullStringForKey:@"status"]) {
		lock.status = JSON[@"status"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"room"]) {
		QURoom *room = [[QURoomManager sharedManager] updateOrCreateEntityWithJSON:JSON[@"room"]];

		if (lock.room != room) {
			lock.room = room;
			didUpdateAtLeastOneValue = YES;
		}
	}
    
    // DLOG(@"Update lock %@ with JSON %@", lock, JSON);

	return didUpdateAtLeastOneValue;
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
		 QULock *lock = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];
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
		 QULock *lock = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];
		 successHandler(lock);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)synchronizeLockWithLockID:(NSNumber *)lockID successHandler:(void (^)(QULock *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointLock stringByReplacingOccurrencesOfString:@":lockID" withString:[lockID stringValue]];
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllLocksWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointLocks successHandler:successHandler failureHandler:failureHandler];
}

@end
