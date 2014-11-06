//
//  SLCoreDataManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SLCoreDataManager : NSObject

+ (SLCoreDataManager *)sharedManager;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/**
 * Saves all changes (e.g. insertions, updates, deletions) of all core data objects since the last
 * time this method was called or since the manager was instantiated.
 * @author  Pascal Fritzen
 */
- (void)save;

/**
 * Discards all changes (e.g. insertions, updates, deletions) of all core data objects since the last
 * time the method @p-(void)save was called.
 * @author  Pascal Fritzen
 */
- (void)discardChanges;

@end
