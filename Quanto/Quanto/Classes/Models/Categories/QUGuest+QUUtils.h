//
//  QUGuest+QUUtils.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUGuest.h"

@interface QUGuest (QUUtils)

- (void)downloadAvatarWithSuccessHandler:(void(^)(void))successHandler failureHandler:(void(^)(NSError *error))failureHandler;

@end
