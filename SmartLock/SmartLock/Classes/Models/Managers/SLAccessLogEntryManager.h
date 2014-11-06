//
//  SLAccessLogEntryManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLAccessLogEntry.h"
#import "SLEntityManager.h"

@interface SLAccessLogEntryManager : SLEntityManager

+ (void)synchronizeAccessLogEntryWithAccessLogEntryID:(NSNumber *)accessLogEntryID completionHandler:(void (^)(NSError *error, SLAccessLogEntry *accessLogEntry))completionHandler;
+ (void)synchronizeAllAccessLogEntriesWithCompletionHandler:(void (^)(NSError *error, NSArray *accessLogEntries))completionHandler;

@end
