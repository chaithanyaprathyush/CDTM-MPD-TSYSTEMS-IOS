//
//  NSDictionary+LMUtils.m
//  LoyaltyManagement
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "NSDictionary+LMUtils.h"

@implementation NSDictionary (LMUtils)

static NSDateFormatter *dateFormatter = nil;

- (NSDate *)dateForKey:(NSString *)key
{
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-mm-ddTHH:mm:ss";
    }
    return [dateFormatter dateFromString:[self valueForKey:key]];
}

@end