//
//  SLLock+SLRESTAPI.m
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLock+SLRESTAPI.h"

@implementation SLLock (SLRESTAPI)

+ (RKEntityMapping *)entityMappingForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
	RKEntityMapping *lockMapping = [RKEntityMapping mappingForEntityForName:@"SLLock" inManagedObjectStore:managedObjectStore];

	[lockMapping addAttributeMappingsFromDictionary:@{
		 @"date_created" : @"createdAt",
		 @"last_modified" : @"lastModifiedAt",
         @"location_lat" : @"locationLat",
         @"location_lon" : @"locationLon",
         @"id" : @"lockID",
		 @"name" : @"name",
		 @"status" : @"status",
	 }];

	lockMapping.identificationAttributes = @[@"lockID"];

	return lockMapping;
}

@end
