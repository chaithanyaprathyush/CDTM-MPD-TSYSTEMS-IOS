//
//  UIView+QURound.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QURound)

- (void)makeRound;
- (void)makeRoundWithBorderWidth:(CGFloat)borderWidth;
- (void)makeRoundWithColor:(UIColor *)color;
- (void)makeRoundWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

- (void)makeAlmostSquared;

- (void)showBorderWithCornerRadius:(CGFloat)cornerRadius color:(UIColor *)color borderWidth:(CGFloat)borderWidth;

@end
