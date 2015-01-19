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

#pragma mark - Singleton

+ (QUKeyManager *)sharedManager
{
	static QUKeyManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUKeyManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QUKey class];

		self.entityLocalIDKey = @"keyID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
    BOOL didUpdateAtLeastOneValue = NO;
    
    QUKey *key = entity;
    
    if ([JSON hasNonNullStringForKey:@"name"]) {
        key.name = JSON[@"name"];
        didUpdateAtLeastOneValue = YES;
    }

	if (JSON[@"locks"]) {
		key.locks = [[QULockManager sharedManager] updateOrCreateEntitiesWithJSON:JSON[@"locks"]];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
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
		[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyKeys successHandler:^(NSSet *fetchedRemoteEntities) {
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
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

@end
