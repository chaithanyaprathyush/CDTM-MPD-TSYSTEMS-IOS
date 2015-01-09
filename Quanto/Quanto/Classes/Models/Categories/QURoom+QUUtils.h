//
//  QURoom+QUUtils.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QURoom.h"

@interface QURoom (QUUtils)

- (void)downloadPictureWithSuccessHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
