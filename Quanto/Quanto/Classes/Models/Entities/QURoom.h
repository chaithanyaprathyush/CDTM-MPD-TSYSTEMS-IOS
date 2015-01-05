//
//  QURoom.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QULock, QUStay;

@interface QURoom : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * roomID;
@property (nonatomic, retain) NSSet *locks;
@property (nonatomic, retain) NSSet *stays;
@property (nonatomic, retain) NSSet *orders;
@end

@interface QURoom (CoreDataGeneratedAccessors)

- (void)addLocksObject:(QULock *)value;
- (void)removeLocksObject:(QULock *)value;
- (void)addLocks:(NSSet *)values;
- (void)removeLocks:(NSSet *)values;

- (void)addStaysObject:(QUStay *)value;
- (void)removeStaysObject:(QUStay *)value;
- (void)addStays:(NSSet *)values;
- (void)removeStays:(NSSet *)values;

- (void)addOrdersObject:(NSManagedObject *)value;
- (void)removeOrdersObject:(NSManagedObject *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
