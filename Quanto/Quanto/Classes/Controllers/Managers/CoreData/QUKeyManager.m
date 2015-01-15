//
//  QUKeyManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 01.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUKeyManager.h"
#import "QULockManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointKey       = @"keys/:keyID/";
static NSString *QUAPIEndpointMyKeys    = @"keys/my/";

@implementation QUKeyManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [QUKey class];
}

+ (NSString *)entityIDKey
{
	return @"keyID";
}

+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	QUKey *key = entity;

    key.name = JSON[@"name"];
    key.locks = [QULockManager updateOrCreateEntitiesWithJSON:JSON[@"locks"]];
    
	// userProfile.user = [QUUserManager updateOrCreateEntityWithJSON:JSON[@"user"]];

	/*
	   if (JSON[@"image"] != (id)[NSNull null]) {
	    userProfile.avatarURL = JSON[@"image"];
	   }*/

	DLOG(@"Updated QUKey with JSON:%@\n%@", JSON, key);
	//DLOG(@"Updated QUKey %@", key.name);
}

#pragma mark - REST-API

+ (void)synchronizeAllMyKeysWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
    // first, get all current keys in order to determine later, which keys were erased (or guest has no access to anymore)
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QUKey class])];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"keyID" ascending:NO]];
    
    NSError *error = nil;
    NSMutableArray *allKeysBeforeFetching = [[[PFCoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    if (allKeysBeforeFetching == nil) {
        failureHandler(error);
    } else {
        [super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyKeys successHandler:^(NSSet *fetchedRemoteEntities) {
            // Remove keys that weren't sent but were there before --> key not valid any longer / guest lost key privileges
            [allKeysBeforeFetching removeObjectsInArray:[fetchedRemoteEntities allObjects]];

            if (allKeysBeforeFetching.count >= 1) {
                for (QUKey *key in allKeysBeforeFetching) {
                    [[PFCoreDataManager sharedManager].managedObjectContext deleteObject:key];
                }
                [[PFCoreDataManager sharedManager] save];
            }
            
            successHandler(fetchedRemoteEntities);
        } failureHandler:failureHandler];
    }
}

+ (void)synchronizeKeyWithKeyID:(NSNumber *)keyID successHandler:(void (^)(QUKey *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointKey stringByReplacingOccurrencesOfString:@":keyID" withString:[keyID stringValue]];
	[super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

@end
