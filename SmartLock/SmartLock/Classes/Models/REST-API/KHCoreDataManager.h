//
//  KHDatabaseManager.h
//  KneeHapp
//
//  Created by Pascal Fritzen on 01.05.14.
//  Copyright (c) 2014 Praxis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KHPatient+CoreData.h"
#import "KHSensorDataSession.h"
#import "KHSensorData.h"
#import "KHOneLegHopExercise+CoreData.h"
#import "KHRangeOfMotionExercise+CoreData.h"
#import "KHOneLegSquatExercise+CoreData.h"
#import "KHRunningInEightsExercise+CoreData.h"

/**
 * The KHCoreDataManager class provides a single point of communicating with the sqlite database.
 * By offering high-level methods (e.g. @c -(void)save , @c -(void)discardChanges), it represents
 * a high level abstraction layer other software components can comfortably interact with.
 * @author  Pascal Fritzen
 */
@interface KHCoreDataManager : NSObject

/**
 * Creates and returns the singleton instance of the core data manager.
 * @author  Pascal Fritzen
 * @return  The singleton instance of the core data manager.
 */
+ (KHCoreDataManager *)sharedManager;


/**
 * The managed object context of the core data manager.
 * @note    This managed object context is shared amongst all CoreData-related classes and only those
 * classes (except NSFetchedResultsController) should access it therefore.
 * @author  Pascal Fritzen
 */
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
