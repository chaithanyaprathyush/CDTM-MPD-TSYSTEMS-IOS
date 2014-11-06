//
//  LMEntityManager.m
//  LoyaltyManagement
//
//  Created by Pascal Fritzen on 04.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "LMEntityManager.h"

@implementation LMEntityManager

+ (NSString *)entityIDKey
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
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

+ (id)fetchOrCreateEntityWithEntityID:(NSNumber *)entityID
{
	id fetchedEntity = [self fetchEntityWithEntityID:entityID];

	if (!fetchedEntity) {
		fetchedEntity = [self createEntityWithEntityID:entityID];
	}

	return fetchedEntity;
}

+ (id)fetchEntityWithEntityID:(NSNumber *)entityID
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %i", [self entityIDKey], [entityID longLongValue]];
	fetchRequest.sortDescriptors = @[];

	NSError *error = nil;
	NSArray *fetchedObjects = [[LMCoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];

	if (fetchedObjects == nil) {
		NSLog(@"Error in %@: %@", NSStringFromSelector(_cmd), error);
	}

    return fetchedObjects.count >= 1 ? fetchedObjects.firstObject : nil;
}

+ (id)createEntityWithEntityID:(NSNumber *)entityID
{
	id entity = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
											  inManagedObjectContext:[LMCoreDataManager sharedManager].managedObjectContext];

	[entity setValue:entityID forKey:[self entityIDKey]];

	[[LMCoreDataManager sharedManager] save];

	return entity;
}

+ (id)updateOrCreateEntityWithJSON:(NSDictionary *)JSON
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (id)updateOrCreateEntitiesWithJSON:(NSDictionary *)JSON
{
	NSMutableArray *entities = [NSMutableArray array];

	for (NSDictionary *entityJSON in JSON) {
		[entities addObject:[self updateOrCreateEntityWithJSON:entityJSON]];
	}

	return entities;
}

@end
