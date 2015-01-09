//
//  MBProgressHUD+QUUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "MBProgressHUD+QUUtils.h"

@implementation MBProgressHUD (QUUtils)

- (void)showCheckmark
{
    [self showCustomViewWithImageName:@"checkmark"];
}

- (void)showCross
{
    [self showCustomViewWithImageName:@"closeButton"];
}

- (void)showCustomViewWithImageName:(NSString *)imageName
{
    // Show checkmark
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.mode = MBProgressHUDModeCustomView;
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay completionHandler:(void (^)(void))completionHandler
{
    [self hide:animated afterDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay + 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionHandler();
    });
}

- (void)showCrossAndHide:(BOOL)animated afterDelay:(NSTimeInterval)delay completionHandler:(void (^)(void))completionHandler
{
    [self showCross];
    [self hide:animated afterDelay:delay completionHandler:completionHandler];
}

- (void)showCheckmarkAndHide:(BOOL)animated afterDelay:(NSTimeInterval)delay completionHandler:(void (^)(void))completionHandler
{
    [self showCheckmark];
    [self hide:animated afterDelay:delay completionHandler:completionHandler];
}


@end
