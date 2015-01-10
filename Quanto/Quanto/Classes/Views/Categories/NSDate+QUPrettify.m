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
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CET"]];
    dateFormatter.dateFormat = @"EEE, dd. MMM YYYY";
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)asHHMM
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60*60*2]];
    dateFormatter.dateFormat = @"HH:mm";
    
    return [dateFormatter stringFromDate:self];
}

@end
