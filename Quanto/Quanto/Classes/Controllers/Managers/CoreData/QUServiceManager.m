//
//  QUServiceManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUServiceManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointServices  = @"services/";
static NSString *QUAPIEndpointService   = @"services/:serviceID/";

@implementation QUServiceManager

#pragma mark - Singleton

+ (QUServiceManager *)sharedManager
{
	static QUServiceManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUServiceManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QUService class];

		self.entityLocalIDKey = @"serviceID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QUService *service = entity;

	if ([JSON hasNonNullStringForKey:@"name"]) {
		service.name = JSON[@"name"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"description"]) {
		service.descriptionText = JSON[@"description"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"picture"]) {
		service.pictureURL = JSON[@"picture"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"enabled"]) {
		service.enabled = JSON[@"enabled"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"price"]) {
		service.price = JSON[@"price"];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
}

#pragma mark - REST-API

+ (void)synchronizeServiceWithServiceID:(NSNumber *)serviceID successHandler:(void (^)(QUService *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointService stringByReplacingOccurrencesOfString:@":serviceID" withString:[serviceID stringValue]];
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllServicesWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointServices successHandler:successHandler failureHandler:failureHandler];
}

@end
