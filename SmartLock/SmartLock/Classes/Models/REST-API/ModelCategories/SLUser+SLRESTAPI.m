//
//  SLUser+SLRESTAPI.m
//  SmartLock
//
//  Created by Pascal Fritzen on 31.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUser+SLRESTAPI.h"

@implementation SLUser (SLRESTAPI)

+ (RKEntityMapping *)entityMappingForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
	RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"SLUser" inManagedObjectStore:managedObjectStore];

	[userMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"userID",
		 @"email" : @"email",
		 @"username" : @"username",
		 @"first_name" : @"firstName",
		 @"last_name" : @"lastName",
		 @"date_joined" : @"joinedAt",
		 @"password" : @"password"
	 }];

	userMapping.identificationAttributes = @[@"userID"];

	return userMapping;
}

@end
