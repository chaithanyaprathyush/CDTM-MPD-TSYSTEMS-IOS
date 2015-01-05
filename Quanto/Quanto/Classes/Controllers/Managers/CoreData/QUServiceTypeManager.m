//
//  QUServiceTypeManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUServiceTypeManager.h"
#import "QUServiceManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointServiceTypes     = @"service-types/";
static NSString *QUAPIEndpointServiceType      = @"service-types/:serviceTypeID/";

@implementation QUServiceTypeManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [QUServiceType class];
}

+ (NSString *)entityIDKey
{
	return @"serviceTypeID";
}

+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	QUServiceType *serviceType = entity;

	serviceType.name = JSON[@"name"];
	serviceType.descriptionText = JSON[@"description"];

	if ([JSON hasNonNullStringForKey:@"article_id"]) {
		serviceType.pictureURL = JSON[@"picture"];
	}

	serviceType.enabled = JSON[@"enabled"];
	serviceType.services = [QUServiceManager updateOrCreateEntitiesWithJSON:JSON[@"services"]];

	// DLOG(@"Updated User Profile with JSON:%@\n%@", JSON, userProfile);
	DLOG(@"Updated QUServiceType %@", serviceType.name);
}

#pragma mark - REST-API

+ (void)synchronizeServiceTypeWithServiceTypeID:(NSNumber *)serviceTypeID successHandler:(void (^)(QUServiceType *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointServiceType stringByReplacingOccurrencesOfString:@":serviceTypeID" withString:[serviceTypeID stringValue]];
	[super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllServiceTypesWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointServiceTypes successHandler:successHandler failureHandler:failureHandler];
}

@end
