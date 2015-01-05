//
//  QUKeyManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 01.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUKey.h"

@interface QUKeyManager : PFEntityManager

+ (void)synchronizeKeyWithKeyID:(NSNumber *)keyID successHandler:(void (^)(QUKey *key))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllMyKeysWithSuccessHandler:(void (^)(NSSet *keys))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
