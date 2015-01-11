//
//  UIView+QUGradient.m
//  Quanto
//
//  Created by Pascal Fritzen on 11.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "UIView+QUGradient.h"

@implementation UIView (QUGradient)

- (void)addGradient
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.frame;
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor darkerDarkGrayColor].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
