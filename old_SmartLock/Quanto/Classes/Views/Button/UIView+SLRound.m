//
//  UIView+SLRound.m
//  Quanto
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "UIView+SLRound.h"

@implementation UIView (SLRound)

- (void)makeRound
{
	[self makeRoundWithColor:[UIColor blueColor] borderWidth:2.0f];
}

- (void)makeRoundWithBorderWidth:(CGFloat)borderWidth
{
	[self makeRoundWithColor:[UIColor blueColor] borderWidth:borderWidth];
}

- (void)makeRoundWithColor:(UIColor *)color
{
	[self makeRoundWithColor:color borderWidth:2.0f];
}

- (void)makeRoundWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
	self.layer.cornerRadius = self.bounds.size.width / 2;
	self.layer.borderColor = color.CGColor;
	self.layer.borderWidth = borderWidth;
	self.layer.masksToBounds = YES;
}

@end
