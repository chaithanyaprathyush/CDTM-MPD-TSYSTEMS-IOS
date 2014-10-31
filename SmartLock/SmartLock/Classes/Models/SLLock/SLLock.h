//
//  SLLock.h
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLLock : NSObject

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *status;

- (BOOL)isOpen;
- (BOOL)isClosed;

@end
