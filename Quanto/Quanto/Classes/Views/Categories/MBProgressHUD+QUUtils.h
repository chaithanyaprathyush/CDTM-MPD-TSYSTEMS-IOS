//
//  MBProgressHUD+QUUtils.h
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (QUUtils)

- (void)showCheckmark;
- (void)showCross;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay completionHandler:(void(^)(void))completionHandler;
- (void)showCheckmarkAndHide:(BOOL)animated afterDelay:(NSTimeInterval)delay completionHandler:(void(^)(void))completionHandler;
- (void)showCrossAndHide:(BOOL)animated afterDelay:(NSTimeInterval)delay completionHandler:(void (^)(void))completionHandler;

@end
