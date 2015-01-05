//
//  QUServiceManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUService.h"

@interface QUServiceManager : PFEntityManager

+ (void)synchronizeServiceWithServiceID:(NSNumber *)serviceID successHandler:(void (^)(QUService *service))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllServicesWithSuccessHandler:(void (^)(NSSet *services))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
