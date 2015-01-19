//
//  PFEntityManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCoreDataManager.h"
#import "PFRESTManager.h"

@interface PFEntityManager : NSObject

// ID's
@property (nonatomic, retain) NSString *entityLocalIDKey;
@property (nonatomic, retain) NSString *entityRemoteIDKey;

// Entity class
@property (nonatomic) Class entityClass;
@property (nonatomic, retain) NSString *entityName;

#pragma mark - CoreData

- (id)createEntityWithEntityID:(NSNumber *)entityID;

- (id)fetchEntityWithEntityID:(NSNumber *)entityID;

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON;

- (id)fetchOrCreateEntityWithEntityID:(NSNumber *)entityID;
- (NSSet *)fetchOrCreateEntitiesWithEntityIDs:(NSArray *)entityIDs;

- (id)updateOrCreateEntityWithJSON:(NSDictionary *)JSON;
- (NSSet *)updateOrCreateEntitiesWithJSON:(id)JSON;


- (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
- (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

- (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
- (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
