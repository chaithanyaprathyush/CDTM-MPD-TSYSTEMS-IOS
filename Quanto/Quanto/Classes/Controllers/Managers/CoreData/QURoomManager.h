//
//  QURoomManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 01.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QURoom.h"

@interface QURoomManager : PFEntityManager

+ (void)synchronizeRoomWithRoomID:(NSNumber *)roomID successHandler:(void (^)(QURoom *room))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllRoomsWithSuccessHandler:(void (^)(NSSet *rooms))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
