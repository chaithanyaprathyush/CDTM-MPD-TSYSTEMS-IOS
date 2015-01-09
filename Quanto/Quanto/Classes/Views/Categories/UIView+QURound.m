//
//  UIView+QURound.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "UIView+QURound.h"

@implementation UIView (QURound)

- (void)makeRound
{
	[self makeRoundWithColor:[UIColor peterRiverColor] borderWidth:2.0f];
}

- (void)makeRoundWithBorderWidth:(CGFloat)borderWidth
{
	[self makeRoundWithColor:[UIColor peterRiverColor] borderWidth:borderWidth];
}

- (void)makeRoundWithColor:(UIColor *)color
{
	[self makeRoundWithColor:color borderWidth:2.0f];
}

- (void)makeRoundWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    [self showBorderWithCornerRadius:self.bounds.size.width / 2 color:color borderWidth:borderWidth];
}

- (void)showBorderWithCornerRadius:(CGFloat)cornerRadius color:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

- (void)makeAlmostSquared
{
    [self showBorderWithCornerRadius:5.0f color:[UIColor peterRiverColor] borderWidth:2.0f];
}

@end
