//
//  SLAccessLogEntry.h
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLAccessLogEntry : NSObject

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSNumber *userIdentifier;
@property (nonatomic, retain) NSNumber *lockIdentifier;
@property (nonatomic, retain) NSNumber *keyIdentifier;

@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) NSDate *createdAt;

@end
