//
//  LMEntityManager.h
//  LoyaltyManagement
//
//  Created by Pascal Fritzen on 04.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMCoreDataManager.h"

@interface LMEntityManager : NSObject

#pragma mark - CoreData

// MUST OVERRIDE!
+ (NSString *)entityIDKey;

// MUST OVERRIDE!
+ (Class)entityClass;

+ (id)createEntityWithEntityID:(NSNumber *)entityID;

+ (id)fetchEntityWithEntityID:(NSNumber *)entityID;

+ (id)fetchOrCreateEntityWithEntityID:(NSNumber *)entityID;

// MUST OVERRIDE!
+ (id)updateOrCreateEntityWithJSON:(NSDictionary *)JSON;

+ (id)updateOrCreateEntitiesWithJSON:(NSDictionary *)JSON;

@end
