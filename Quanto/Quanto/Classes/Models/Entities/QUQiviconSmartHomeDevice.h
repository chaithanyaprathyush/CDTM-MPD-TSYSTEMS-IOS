//
//  QUQiviconSmartHomeDevice.h
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QUQiviconSmartHomeDevice : NSManagedObject

@property (nonatomic, retain) NSNumber * qiviconSmartHomeDeviceID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * type;

@end
