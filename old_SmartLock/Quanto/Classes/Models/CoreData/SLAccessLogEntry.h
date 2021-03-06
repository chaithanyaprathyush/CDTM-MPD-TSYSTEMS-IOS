//
//  SLAccessLogEntry.h
//  Quanto
//
//  Created by Pascal Fritzen on 02.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLLock, SLUser;

@interface SLAccessLogEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * accessLogEntryID;
@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * keyID;
@property (nonatomic, retain) NSNumber * lockID;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) SLLock *lock;
@property (nonatomic, retain) SLUser *user;

@end
