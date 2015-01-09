//
//  QURoom.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QULock, QUOrder, QUStay;

@interface QURoom : NSManagedObject

@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * roomID;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSData * pictureData;
@property (nonatomic, retain) NSSet *locks;
@property (nonatomic, retain) NSSet *orders;
@property (nonatomic, retain) NSSet *stays;
@end

@interface QURoom (CoreDataGeneratedAccessors)

- (void)addLocksObject:(QULock *)value;
- (void)removeLocksObject:(QULock *)value;
- (void)addLocks:(NSSet *)values;
- (void)removeLocks:(NSSet *)values;

- (void)addOrdersObject:(QUOrder *)value;
- (void)removeOrdersObject:(QUOrder *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

- (void)addStaysObject:(QUStay *)value;
- (void)removeStaysObject:(QUStay *)value;
- (void)addStays:(NSSet *)values;
- (void)removeStays:(NSSet *)values;

@end
