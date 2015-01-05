//
//  UIColor+QUCorporateDesign.m
//  Quanto
//
//  Created by Pascal Fritzen on 01.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "UIColor+QUCorporateDesign.h"

static NSString *goldColorHexCode = @"daa520";
static NSString *lighterDarkGrayColorHexCode = @"222325";
static NSString *darkerDarkGrayColorHexCode = @"202123";

@implementation UIColor (QUCorporateDesign)

+ (UIColor *)goldColor
{
	return [self colorWithHexString:goldColorHexCode];
}

+ (UIColor *)lighterDarkGrayColor
{
	return [self colorWithHexString:lighterDarkGrayColorHexCode];
}

+ (UIColor *)darkerDarkGrayColor
{
	return [self colorWithHexString:darkerDarkGrayColorHexCode];
}

#pragma mark - Utils

// see http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background
+ (UIColor *)colorWithHexString:(NSString*)hex
{
	NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

	// String should be 6 or 8 characters
	if ([cString length] < 6) return [UIColor grayColor];

	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

	if ([cString length] != 6) return [UIColor grayColor];

	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];

	range.location = 2;
	NSString *gString = [cString substringWithRange:range];

	range.location = 4;
	NSString *bString = [cString substringWithRange:range];

	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];

	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

@end
