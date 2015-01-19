//
//  QUOrder.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QURoom, QUService;

@interface QUOrder : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * lastModifiedAt;
@property (nonatomic, retain) NSNumber * orderID;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) QURoom *room;
@property (nonatomic, retain) QUService *service;

@end
