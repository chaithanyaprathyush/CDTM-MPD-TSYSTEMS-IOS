//
//  NSDictionary+PFUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "NSDictionary+PFUtils.h"

@implementation NSDictionary (PFUtils)

static NSDateFormatter *dateFormatter = nil;

- (NSDate *)dateForKey:(NSString *)key
{
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    }
    
    NSString *dateAsString = [self valueForKey:key];
    NSDate *date = [dateFormatter dateFromString:dateAsString];
        
    return date;
}

- (BOOL)hasNonNullStringForKey:(NSString *)key
{
    return [self valueForKey:key] != (id)[NSNull null] && [self valueForKey:key];
}

@end
