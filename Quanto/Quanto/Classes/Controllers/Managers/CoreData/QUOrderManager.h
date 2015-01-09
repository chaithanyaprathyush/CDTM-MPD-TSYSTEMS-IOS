//
//  QUOrderManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUOrder.h"

@interface QUOrderManager : PFEntityManager

+ (void)createOrderForService:(QUService *)service successHandler:(void (^)(QUOrder *order))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)synchronizeOrderWithOrderID:(NSNumber *)orderID successHandler:(void (^)(QUOrder *order))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllMyOrdersWithSuccessHandler:(void (^)(NSSet *orders))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)deleteOrderWithOrderID:(NSNumber *)orderID successHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
