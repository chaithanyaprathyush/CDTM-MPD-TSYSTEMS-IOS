//
//  QULock+QUUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 10.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QULock+QUUtils.h"

@implementation QULock (QUUtils)

- (BOOL)isOpen
{
    return [self.status isEqual:@"OPEN"];
}

- (BOOL)isClosed
{
    return [self.status isEqual:@"CLOSED"];
}

@end
