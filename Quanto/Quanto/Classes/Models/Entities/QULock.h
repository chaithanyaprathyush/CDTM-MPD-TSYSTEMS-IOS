//
//  QULock.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QUKey, QURoom;

@interface QULock : NSManagedObject

@property (nonatomic, retain) NSNumber * locationLat;
@property (nonatomic, retain) NSNumber * locationLon;
@property (nonatomic, retain) NSNumber * lockID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *keys;
@property (nonatomic, retain) QURoom *room;
@end

@interface QULock (CoreDataGeneratedAccessors)

- (void)addKeysObject:(QUKey *)value;
- (void)removeKeysObject:(QUKey *)value;
- (void)addKeys:(NSSet *)values;
- (void)removeKeys:(NSSet *)values;

@end
