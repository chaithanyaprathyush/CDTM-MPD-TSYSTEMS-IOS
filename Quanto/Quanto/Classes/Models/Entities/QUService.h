//
//  QUService.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QUOrder, QUServiceType;

@interface QUService : NSManagedObject

@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * pictureData;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * serviceID;
@property (nonatomic, retain) NSSet *orders;
@property (nonatomic, retain) QUServiceType *serviceType;
@end

@interface QUService (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(QUOrder *)value;
- (void)removeOrdersObject:(QUOrder *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
