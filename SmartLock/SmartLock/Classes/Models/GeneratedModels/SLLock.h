//
//  SLLock.h
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLAccessLogEntry;

@interface SLLock : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * lastModifiedAt;
@property (nonatomic, retain) NSNumber * locationLat;
@property (nonatomic, retain) NSNumber * locationLon;
@property (nonatomic, retain) NSNumber * lockID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *accessLogEntries;
@end

@interface SLLock (CoreDataGeneratedAccessors)

- (void)addAccessLogEntriesObject:(SLAccessLogEntry *)value;
- (void)removeAccessLogEntriesObject:(SLAccessLogEntry *)value;
- (void)addAccessLogEntries:(NSSet *)values;
- (void)removeAccessLogEntries:(NSSet *)values;

@end
