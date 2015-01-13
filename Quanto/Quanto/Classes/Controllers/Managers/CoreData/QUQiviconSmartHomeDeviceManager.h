//
//  QUQiviconSmartHomeDeviceManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUQiviconSmartHomeDevice.h"

@interface QUQiviconSmartHomeDeviceManager : PFEntityManager

+ (void)synchronizeQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:(NSNumber *)qiviconSmartHomeDeviceID successHandler:(void (^)(QUQiviconSmartHomeDevice *qiviconSmartHomeDevice))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllMyQiviconSmartHomeDevicesWithSuccessHandler:(void (^)(NSSet *qiviconSmartHomeDevices))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)turnOnQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:(NSNumber *)qiviconSmartHomeDeviceID successHandler:(void (^)(QUQiviconSmartHomeDevice *qiviconSmartHomeDevice))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)turnOffQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:(NSNumber *)qiviconSmartHomeDeviceID successHandler:(void (^)(QUQiviconSmartHomeDevice *qiviconSmartHomeDevice))successHandler failureHandler:(void (^)(NSError *error))failureHandler;


@end
