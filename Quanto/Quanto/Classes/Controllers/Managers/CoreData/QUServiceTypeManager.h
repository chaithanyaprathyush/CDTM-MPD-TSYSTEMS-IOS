//
//  QUServiceTypeManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUServiceType.h"

@interface QUServiceTypeManager : PFEntityManager

+ (void)synchronizeServiceTypeWithServiceTypeID:(NSNumber *)serviceTypeID successHandler:(void (^)(QUServiceType *serviceType))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllServiceTypesWithSuccessHandler:(void (^)(NSSet *serviceTypes))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
