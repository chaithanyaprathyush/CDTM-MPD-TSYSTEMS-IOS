//
//  SLAccessLogEntryManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLAccessLogEntry.h"

@interface SLAccessLogEntryManager : NSObject

+ (SLAccessLogEntryManager *)sharedManager;

@property (nonatomic, retain) NSMutableArray *responseDescriptors;
@property (nonatomic, retain) NSMutableArray *requestDescriptors;

- (void)fetchAllAccessLogEntriesWithCompletionHandler:(void (^)(NSError *error, NSArray *accessLogEntries))completionHandler;

@end
