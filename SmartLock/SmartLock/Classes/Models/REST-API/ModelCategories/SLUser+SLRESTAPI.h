//
//  SLUser+SLRESTAPI.h
//  SmartLock
//
//  Created by Pascal Fritzen on 31.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUser.h"
#import <RestKit/RestKit.h>

@interface SLUser (SLRESTAPI)

+ (RKEntityMapping *)entityMappingForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;

@end
