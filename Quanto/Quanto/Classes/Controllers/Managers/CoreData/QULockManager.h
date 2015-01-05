//
//  QULockManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 30.12.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QULock.h"

@interface QULockManager : PFEntityManager

+ (void)synchronizeLockWithLockID:(NSNumber *)lockID successHandler:(void (^)(QULock *lock))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllLocksWithSuccessHandler:(void (^)(NSSet *locks))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)openLock:(QULock *)lock withCompletionHandler:(void (^)(NSError *error, QULock *lock))completionHandler;
+ (void)closeLock:(QULock *)lock withCompletionHandler:(void (^)(NSError *error, QULock *lock))completionHandler;

@end
