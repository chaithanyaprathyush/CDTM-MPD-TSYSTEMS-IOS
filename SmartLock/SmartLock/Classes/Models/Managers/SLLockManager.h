//
//  SLLockManager.h
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLLock.h"
#import "SLEntityManager.h"

@interface SLLockManager : SLEntityManager

+ (void)synchronizeLockWithLockID:(NSNumber *)lockID completionHandler:(void (^)(NSError *error, SLLock *lock))completionHandler;
+ (void)synchronizeAllLocksWithCompletionHandler:(void (^)(NSError *error, NSArray *locks))completionHandler;

+ (void)openLock:(SLLock *)lock withCompletionHandler:(void(^)(NSError *error, SLLock *lock))completionHandler;
+ (void)closeLock:(SLLock *)lock withCompletionHandler:(void(^)(NSError *error, SLLock *lock))completionHandler;

@end
