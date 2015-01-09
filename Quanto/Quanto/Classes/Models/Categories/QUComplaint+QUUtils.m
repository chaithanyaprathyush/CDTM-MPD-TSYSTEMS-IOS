//
//  QUComplaint+QUUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUComplaint+QUUtils.h"

@implementation QUComplaint (QUUtils)

- (NSString *)lastModifiedAtDateOnly
{
    return [self.lastModifiedAt asEEEddMMMYYYY];
}

@end
