//
//  QUBluetoothManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 02.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QUBluetoothManager : NSObject

+ (QUBluetoothManager *)sharedManager;

+ (void)setAuthenticationToken:(NSString *)authenticationToken;

+ (BOOL)isAdvertisingServices;
+ (void)startAdvertisingServices;
+ (void)stopAdvertisingServices;

@end
