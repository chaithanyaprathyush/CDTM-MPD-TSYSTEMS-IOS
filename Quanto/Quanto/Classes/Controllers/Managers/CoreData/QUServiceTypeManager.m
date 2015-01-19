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

#pragma mark - Singleton

+ (QUServiceTypeManager *)sharedManager
{
	static QUServiceTypeManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUServiceTypeManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QUServiceType class];

		self.entityLocalIDKey = @"serviceTypeID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QUServiceType *serviceType = entity;

	if ([JSON hasNonNullStringForKey:@"name"]) {
		serviceType.name = JSON[@"name"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"description"]) {
		serviceType.descriptionText = JSON[@"description"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"picture"]) {
		serviceType.pictureURL = JSON[@"picture"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"enabled"]) {
		serviceType.enabled = JSON[@"enabled"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"services"]) {
		serviceType.services = [[QUServiceManager sharedManager] updateOrCreateEntitiesWithJSON:JSON[@"services"]];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
}

#pragma mark - REST-API

+ (void)synchronizeServiceTypeWithServiceTypeID:(NSNumber *)serviceTypeID successHandler:(void (^)(QUServiceType *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointServiceType stringByReplacingOccurrencesOfString:@":serviceTypeID" withString:[serviceTypeID stringValue]];
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllServiceTypesWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointServiceTypes successHandler:successHandler failureHandler:failureHandler];
}

@end
