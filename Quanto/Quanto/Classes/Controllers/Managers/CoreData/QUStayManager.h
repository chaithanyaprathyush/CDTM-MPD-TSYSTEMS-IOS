//
//  QUStayManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 11.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUStay.h"

@interface QUStayManager : PFEntityManager

+ (void)synchronizeStayWithStayID:(NSNumber *)stayID successHandler:(void (^)(QUStay *stay))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllMyStaysWithSuccessHandler:(void (^)(NSSet *stays))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
