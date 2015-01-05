//
//  SLLock.h
//  Quanto
//
//  Created by Pascal Fritzen on 02.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SLLock : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * lastModifiedAt;
@property (nonatomic, retain) NSNumber * locationLat;
@property (nonatomic, retain) NSNumber * locationLon;
@property (nonatomic, retain) NSNumber * lockID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;

@end
