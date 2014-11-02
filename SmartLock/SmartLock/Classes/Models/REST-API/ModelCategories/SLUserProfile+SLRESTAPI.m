//
//  SLUserProfile+SLRESTAPI.m
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUserProfile+SLRESTAPI.h"
#import "SLUser+SLRESTAPI.h"

@implementation SLUserProfile (SLRESTAPI)

+ (RKEntityMapping *)entityMappingForManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
	RKEntityMapping *userProfileMapping = [RKEntityMapping mappingForEntityForName:@"SLUserProfile" inManagedObjectStore:managedObjectStore];

	[userProfileMapping addAttributeMappingsFromDictionary:@{
		 @"avatar" : @"avatarURL",
		 @"id" : @"userProfileID",
	 }];
    [userProfileMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[SLUser entityMappingForManagedObjectStore:managedObjectStore]]];

	userProfileMapping.identificationAttributes = @[@"userProfileID"];

	return userProfileMapping;
}

@end
