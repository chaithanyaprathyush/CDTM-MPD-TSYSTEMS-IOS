//
//  SLLock+SLRESTAPI.h
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLock.h"
#import <RestKit/RestKit.h>

@interface SLLock (SLRESTAPI)

+ (RKEntityMapping *)entityMappingForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;

@end
