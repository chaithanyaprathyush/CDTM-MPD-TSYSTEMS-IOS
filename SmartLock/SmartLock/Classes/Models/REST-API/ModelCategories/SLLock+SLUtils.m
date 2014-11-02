//
//  SLLock+SLUtils.m
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLock+SLUtils.h"

static NSString *LOCK_STATUS_OPEN = @"OPEN";
static NSString *LOCK_STATUS_CLOSED = @"CLOSED";

@implementation SLLock (SLUtils)

- (BOOL)isOpen
{
    return [self.status isEqual:LOCK_STATUS_OPEN];
}

- (BOOL)isClosed
{
    return [self.status isEqual:LOCK_STATUS_CLOSED];
}

@end
