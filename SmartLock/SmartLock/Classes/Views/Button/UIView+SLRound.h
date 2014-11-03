//
//  UIView+SLRound.h
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SLRound)

- (void)makeRound;
- (void)makeRoundWithBorderWidth:(CGFloat)borderWidth;
- (void)makeRoundWithColor:(UIColor *)color;
- (void)makeRoundWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

@end
