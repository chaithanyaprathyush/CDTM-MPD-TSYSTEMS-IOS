//
//  SLLock.m
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLock.h"

static NSString *SLLockStatusOpen = @"OPEN";
static NSString *SLLockStatusClosed = @"CLOSED";

@implementation SLLock

- (BOOL)isOpen
{
    return [self.status isEqualToString:SLLockStatusOpen];
}

- (BOOL)isClosed
{
    return [self.status isEqualToString:SLLockStatusClosed];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@/%@: %@", self.name, self.key, self.status];
}

@end
