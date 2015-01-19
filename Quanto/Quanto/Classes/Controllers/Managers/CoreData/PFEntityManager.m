//
//  PFEntityManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"

@implementation PFEntityManager

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityRemoteIDKey = @"id";
	}
	return self;
}

- (void)setEntityClass:(Class)entityClass
{
	_entityClass = entityClass;
	self.entityName = NSStringFromClass(entityClass);
}

#pragma mark - Local database operations
#pragma mark CREATE

- (id)createEntityWithEntityID:(NSNumber *)entityID
{
	id entity = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
											  inManagedObjectContext:[PFCoreDataManager sharedManager].managedObjectContext];

	[entity setValue:entityID forKey:self.entityLocalIDKey];

	[[PFCoreDataManager sharedManager] save];

	return entity;
}

#pragma mark FETCH

- (id)fetchEntityWithEntityID:(NSNumber *)entityID
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %i", self.entityLocalIDKey, [entityID longLongValue]];
	fetchRequest.sortDescriptors = @[];

	NSError *error = nil;
	NSArray *fetchedObjects = [[PFCoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];

	if (fetchedObjects == nil) {
		NSLog(@"Error in %@: %@", NSStringFromSelector(_cmd), error);
	}

	return fetchedObjects.count >= 1 ? fetchedObjects.firstObject : nil;
}

#pragma mark UPDATE

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	[self doesNotRecognizeSelector:_cmd];
	return NO;
}

#pragma mark FETCH or CREATE

- (id)fetchOrCreateEntityWithEntityID:(NSNumber *)entityID
{
	id fetchedEntity = [self fetchEntityWithEntityID:entityID];

	if (!fetchedEntity) {
		fetchedEntity = [self createEntityWithEntityID:entityID];
	}

	return fetchedEntity;
}

- (NSSet *)fetchOrCreateEntitiesWithEntityIDs:(NSArray *)entityIDs
{
	NSMutableSet *fetchedOrCreatedEntities = [NSMutableSet setWithCapacity:entityIDs.count];

	for (NSNumber *entityID in entityIDs) {
		[fetchedOrCreatedEntities addObject:[self fetchOrCreateEntityWithEntityID:entityID]];
	}

	return fetchedOrCreatedEntities;
}

#pragma mark UPDATE or CREATE

- (id)updateOrCreateEntityWithJSON:(NSDictionary *)JSON
{
	NSNumber *entityID = [JSON valueForKeyPath:self.entityRemoteIDKey];

	id entity = [self fetchOrCreateEntityWithEntityID:entityID];

	BOOL didUpdateAtLeastOneValue = [self updateEntity:entity withJSON:(NSDictionary *)JSON];

	if (didUpdateAtLeastOneValue) {
		[[PFCoreDataManager sharedManager] save];
	}

	return entity;
}

- (NSSet *)updateOrCreateEntitiesWithJSON:(id)JSON
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

- (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[self fetchSingleRemoteEntityAtEndpoint:endpoint withParameters:nil successHandler:successHandler failureHandler:failureHandler];
}

- (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *))failureHandler
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

- (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[self fetchAllRemoteEntitiesAtEndpoint:endpoint withParameters:nil successHandler:successHandler failureHandler:failureHandler];
}

- (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *))failureHandler
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
