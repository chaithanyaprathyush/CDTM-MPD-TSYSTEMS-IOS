//
//  SLLockManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLLock.h"

@interface SLLockManager : NSObject

+ (SLLockManager *)sharedManager;

@property (nonatomic, retain) NSMutableArray *responseDescriptors;
@property (nonatomic, retain) NSMutableArray *requestDescriptors;

- (void)fetchAllLocksWithCompletionHandler:(void(^)(NSError *error, NSArray *locks))completionHandler;
- (void)fetchMyLocksWithCompletionHandler:(void(^)(NSError *error, NSArray *locks))completionHandler;

- (void)fetchLockWithIdentifier:(NSNumber *)identifier completionHandler:(void(^)(NSError *error, SLLock *lock))completionHandler;


- (void)openLock:(SLLock *)lock withCompletionHandler:(void(^)(NSError *error, SLLock *lock))completionHandler;
- (void)closeLock:(SLLock *)lock withCompletionHandler:(void(^)(NSError *error, SLLock *lock))completionHandler;

@end
