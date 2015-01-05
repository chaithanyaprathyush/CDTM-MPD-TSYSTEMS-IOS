//
//  PFRESTManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface PFRESTManager : NSObject

+ (PFRESTManager *)sharedManager;
+ (NSString *)hostAndPortURLAsString;

@property (nonatomic, retain) AFHTTPRequestOperationManager *operationManager;

@end
