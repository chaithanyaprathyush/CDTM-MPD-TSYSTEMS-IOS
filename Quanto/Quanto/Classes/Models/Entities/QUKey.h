//
//  QUKey.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QUGuest, QULock;

@interface QUKey : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * keyID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * validFrom;
@property (nonatomic, retain) NSDate * validUntil;
@property (nonatomic, retain) NSSet *guests;
@property (nonatomic, retain) NSSet *locks;
@end

@interface QUKey (CoreDataGeneratedAccessors)

- (void)addGuestsObject:(QUGuest *)value;
- (void)removeGuestsObject:(QUGuest *)value;
- (void)addGuests:(NSSet *)values;
- (void)removeGuests:(NSSet *)values;

- (void)addLocksObject:(QULock *)value;
- (void)removeLocksObject:(QULock *)value;
- (void)addLocks:(NSSet *)values;
- (void)removeLocks:(NSSet *)values;

@end
