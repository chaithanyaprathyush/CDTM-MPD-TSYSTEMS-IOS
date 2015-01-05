//
//  NSDate+QUPrettify.m
//  Quanto
//
//  Created by Pascal Fritzen on 16.12.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "NSDate+QUPrettify.h"

@implementation NSDate (QUPrettify)

- (NSString *)asEEEddMMMYYYY
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"EEE, dd. MMM YYYY";
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)asHHMM
{
    return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

@end
