//
//  QUStay.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QUGuest, QURoom;

@interface QUStay : NSManagedObject

@property (nonatomic, retain) NSDate * fromDate;
@property (nonatomic, retain) NSNumber * stayID;
@property (nonatomic, retain) NSDate * toDate;
@property (nonatomic, retain) NSSet *guests;
@property (nonatomic, retain) NSSet *rooms;
@end

@interface QUStay (CoreDataGeneratedAccessors)

- (void)addGuestsObject:(QUGuest *)value;
- (void)removeGuestsObject:(QUGuest *)value;
- (void)addGuests:(NSSet *)values;
- (void)removeGuests:(NSSet *)values;

- (void)addRoomsObject:(QURoom *)value;
- (void)removeRoomsObject:(QURoom *)value;
- (void)addRooms:(NSSet *)values;
- (void)removeRooms:(NSSet *)values;

@end
