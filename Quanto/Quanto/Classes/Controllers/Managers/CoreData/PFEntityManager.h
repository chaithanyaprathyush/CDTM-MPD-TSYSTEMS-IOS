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

#pragma mark - CoreData

// MUST OVERRIDE!
+ (NSString *)entityIDKey;

+ (NSString *)remoteEntityIDKey;

// MUST OVERRIDE!
+ (Class)entityClass;

+ (id)createEntityWithEntityID:(NSNumber *)entityID;
+ (NSSet *)fetchOrCreateEntitiesWithEntityIDs:(NSArray *)entityIDs;

+ (id)fetchEntityWithEntityID:(NSNumber *)entityID;

+ (id)fetchOrCreateEntityWithEntityID:(NSNumber *)entityID;

+ (id)updateOrCreateEntityWithJSON:(NSDictionary *)JSON;

+ (BOOL)shouldInvokeSimpleUpdate;

// MUST OVERRIDE ONE OF THE NEXT TWO!
+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON;
+ (BOOL)checkToUpdateEntity:(id)entity withJSON:(NSDictionary *)JSON;

+ (NSSet *)updateOrCreateEntitiesWithJSON:(id)JSON;

+ (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)fetchSingleRemoteEntityAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(id fetchedRemoteEntity))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)fetchAllRemoteEntitiesAtEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters successHandler:(void (^)(NSSet *fetchedRemoteEntities))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
