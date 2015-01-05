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
    // Show checkmark
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
    self.mode = MBProgressHUDModeCustomView;
}

@end
