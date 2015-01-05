//
//  SLAccessLogEntry.m
//  Quanto
//
//  Created by Pascal Fritzen on 02.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLAccessLogEntry.h"
#import "SLLock.h"
#import "SLUser.h"


@implementation SLAccessLogEntry

@dynamic accessLogEntryID;
@dynamic action;
@dynamic createdAt;
@dynamic keyID;
@dynamic lockID;
@dynamic userID;
@dynamic lock;
@dynamic user;

@end
