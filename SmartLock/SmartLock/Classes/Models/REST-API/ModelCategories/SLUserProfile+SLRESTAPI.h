//
//  SLUserProfile+SLRESTAPI.h
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUserProfile.h"
#import <RestKit/RestKit.h>

@interface SLUserProfile (SLRESTAPI)

+ (RKEntityMapping *)entityMappingForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;

@end
