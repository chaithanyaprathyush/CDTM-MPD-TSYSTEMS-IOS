//
//  PFEntityManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"

@implementation PFEntityManager

#pragma mark - Methods to be overridden by subclasses

+ (NSString *)entityIDKey
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

+ (NSString *)remoteEntityIDKey
{
	return @"id";
}

+ (Class)entityClass
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

+ (NSString *)entityName
{
	return NSStringFromClass([self entityClass]);
}

#pragma mark - Local database operations

+ (id)fetchOrCreateEntityWithEntityID:(NSNumber *)entityID
{
	id fetchedEntity = [self fetchEntityWithEntityID:entityID];

	if (!fetchedEntity) {
		fetchedEntity = [self createEntityWithEntityID:entityID];
	}

	return fetchedEntity;
}

+ (NSSet *)fetchOrCreateEntitiesWithEntityIDs:(NSArray *)entityIDs
{
	NSMutableSet *fetchedOrCreatedEntities = [NSMutableSet setWithCapacity:entityIDs.count];

	for (NSNumber *entityID in entityIDs) {
		[fetchedOrCreatedEntities addObject:[self fetchOrCreateEntityWithEntityID:entityID]];
	}

	return fetchedOrCreatedEntities;
}

+ (id)fetchEntityWithEntityID:(NSNumber *)entityID
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %i", [self entityIDKey], [entityID longLongValue]];
	fetchRequest.sortDescriptors = @[];

	NSError *error = nil;
	NSArray *fetchedObjects = [[PFCoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];

	if (fetchedObjects == nil) {
		NSLog(@"Error in %@: %@", NSStringFromSelector(_cmd), error);
	}

	return fetchedObjects.count >= 1 ? fetchedObjects.firstObject : nil;
}

+ (id)createEntityWithEntityID:(NSNumber *)entityID
{
	id entity = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
											  inManagedObjectContext:[PFCoreDataManager sharedManager].managedObjectContext];

	[entity setValue:entityID forKey:[self entityIDKey]];

	[[PFCoreDataManager sharedManager] save];

	return entity;
}

+ (id)updateOrCreateEntityWithJSON:(NSDictionary *)JSON
{
	NSNumber *entityID = [JSON valueForKeyPath:[self remoteEntityIDKey]];

	id entity = [self fetchOrCreateEntityWithEntityID:entityID];

	if ([self shouldInvokeSimpleUpdate]) {
		[self updateEntity:entity withJSON:(NSDictionary *)JSON];
		[[PFCoreDataManager sharedManager] save];
	} else {
		BOOL didUpdateEntity = [self checkToUpdateEntity:entity withJSON:JSON];
		if (didUpdateEntity) {
			[[PFCoreDataManager sharedManager] save];
		}
	}

	return entity;
}

+ (BOOL)shouldInvokeSimpleUpdate
{
	return YES;
}

+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	[self doesNotRecognizeSelector:_cmd];
}

+ (BOOL)checkToUpdateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	[self doesNotRecognizeSelector:_cmd];
	return NO;
}

+ (NSSet *)updateOrCreateEntitiesWithJSON:(id)JSON
{
	NSMutableSet *entities = [NSMutableSet set];

	if ([JSON isKindOfClass:[NSArray class]]) {
		for (NSDictionary *entityJSON in JSON) {
			[entities addObject:[self updateOrCreateEntityWithJSON:entityJSON]];
		}
	} else {
		[entities addObject:[self updateOrCreateEntityWithJSON:JSON]];
	}

	return entities;
}

#pragma mark - Fetching Remote Entities

+ (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[self fetchSingleRemoteEntityAtEndpoint:endpoint withParameters:nil successHandler:successHandler failureHandler:failureHandler];
}

+ (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[PFRESTManager sharedManager].operationManager GET:endpoint
											 parameters:parameters
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 id entity = [self updateOrCreateEntityWithJSON:responseObject];
	     // DLOG(@"Success: %@", entity);
		 DLOG(@"Success!");
		 successHandler(entity);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[self fetchAllRemoteEntitiesAtEndpoint:endpoint withParameters:nil successHandler:successHandler failureHandler:failureHandler];
}

+ (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Endpoint '%@'", endpoint);

	[[PFRESTManager sharedManager].operationManager GET:endpoint
											 parameters:parameters
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 NSSet *entities = [self updateOrCreateEntitiesWithJSON:responseObject[@"results"]];
	     // DLOG(@"Success: %@", entities);
		 DLOG(@"Success!");
		 successHandler(entities);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

@end
