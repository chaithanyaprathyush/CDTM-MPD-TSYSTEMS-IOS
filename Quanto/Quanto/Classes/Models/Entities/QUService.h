//
//  QUService.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QUService : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSData * pictureData;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSNumber * serviceID;
@property (nonatomic, retain) NSManagedObject *serviceType;
@property (nonatomic, retain) NSSet *orders;
@end

@interface QUService (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(NSManagedObject *)value;
- (void)removeOrdersObject:(NSManagedObject *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

@end
