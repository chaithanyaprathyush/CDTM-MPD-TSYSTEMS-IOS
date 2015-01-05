//
//  NSDictionary+PFUtils.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PFUtils)

- (NSDate *)dateForKey:(NSString *)key;

- (BOOL)hasNonNullStringForKey:(NSString *)key;

@end
