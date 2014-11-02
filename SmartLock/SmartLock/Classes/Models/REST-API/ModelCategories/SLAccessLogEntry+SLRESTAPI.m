//
//  SLAccessLogEntry+SLRESTAPI.m
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLAccessLogEntry+SLRESTAPI.h"

@implementation SLAccessLogEntry (SLRESTAPI)

+ (RKEntityMapping *)entityMappingForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
	RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"SLUser" inManagedObjectStore:managedObjectStore];

	[userMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"accessLogEntryID",
		 @"user" : @"userIdentifier",
		 @"lock" : @"lockIdentifier",
		 @"key" : @"keyIdentifier",
		 @"action" : @"action",
		 @"date_created" : @"createdAt"
	 }];

	userMapping.identificationAttributes = @[@"accessLogEntryID"];

	return userMapping;
}

@end
