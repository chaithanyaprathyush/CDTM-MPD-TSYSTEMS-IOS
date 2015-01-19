//
//  QUQiviconSmartHomeDeviceManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUQiviconSmartHomeDeviceManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointQiviconSmartHomeDevices           = @"qivicon-smart-home-devices/";
static NSString *QUAPIEndpointQiviconSmartHomeDevicesMy         = @"qivicon-smart-home-devices/my/";
static NSString *QUAPIEndpointQiviconSmartHomeDevice            = @"qivicon-smart-home-devices/:qiviconSmartHomeDeviceID/";
static NSString *QUAPIEndpointQiviconSmartHomeDeviceTurnOn      = @"qivicon-smart-home-devices/:qiviconSmartHomeDeviceID/turn_on/";
static NSString *QUAPIEndpointQiviconSmartHomeDeviceTurnOff     = @"qivicon-smart-home-devices/:qiviconSmartHomeDeviceID/turn_off/";
static NSString *QUAPIEndpointQiviconSmartHomeDeviceSetState    = @"qivicon-smart-home-devices/:qiviconSmartHomeDeviceID/set_state/";

@implementation QUQiviconSmartHomeDeviceManager

#pragma mark - Singleton

+ (QUQiviconSmartHomeDeviceManager *)sharedManager
{
	static QUQiviconSmartHomeDeviceManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUQiviconSmartHomeDeviceManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QUQiviconSmartHomeDevice class];

		self.entityLocalIDKey = @"qiviconSmartHomeDeviceID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QUQiviconSmartHomeDevice *qiviconSmartHomeDevice = entity;

	if ([JSON hasNonNullStringForKey:@"name"]) {
		qiviconSmartHomeDevice.name = JSON[@"name"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"status"]) {
		qiviconSmartHomeDevice.status = JSON[@"status"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"uid"]) {
		qiviconSmartHomeDevice.uid = JSON[@"uid"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"state"]) {
		qiviconSmartHomeDevice.state = JSON[@"state"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"type"]) {
		qiviconSmartHomeDevice.type = JSON[@"type"];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
}

#pragma mark - REST-API

+ (void)synchronizeQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:(NSNumber *)qiviconSmartHomeDeviceID successHandler:(void (^)(QUQiviconSmartHomeDevice *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointQiviconSmartHomeDevice stringByReplacingOccurrencesOfString:@":qiviconSmartHomeDeviceID" withString:[qiviconSmartHomeDeviceID stringValue]];
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllMyQiviconSmartHomeDevicesWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointQiviconSmartHomeDevicesMy successHandler:successHandler failureHandler:failureHandler];
}

+ (void)turnOnQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:(NSNumber *)qiviconSmartHomeDeviceID successHandler:(void (^)(QUQiviconSmartHomeDevice *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Turn on: %@", [qiviconSmartHomeDeviceID stringValue]);

	NSString *endpoint = [QUAPIEndpointQiviconSmartHomeDeviceTurnOn stringByReplacingOccurrencesOfString:@":qiviconSmartHomeDeviceID" withString:[qiviconSmartHomeDeviceID stringValue]];

	[[PFRESTManager sharedManager].operationManager POST:endpoint
											  parameters:nil
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 QUQiviconSmartHomeDevice *qiviconSmartHomeDevice = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];

		 DLOG(@"Success!");
		 successHandler(qiviconSmartHomeDevice);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)turnOffQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:(NSNumber *)qiviconSmartHomeDeviceID successHandler:(void (^)(QUQiviconSmartHomeDevice *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Turn off: %@", [qiviconSmartHomeDeviceID stringValue]);

	NSString *endpoint = [QUAPIEndpointQiviconSmartHomeDeviceTurnOff stringByReplacingOccurrencesOfString:@":qiviconSmartHomeDeviceID" withString:[qiviconSmartHomeDeviceID stringValue]];

	[[PFRESTManager sharedManager].operationManager POST:endpoint
											  parameters:nil
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 QUQiviconSmartHomeDevice *qiviconSmartHomeDevice = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];

		 DLOG(@"Success!");
		 successHandler(qiviconSmartHomeDevice);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)setStateForQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:(NSNumber *)qiviconSmartHomeDeviceID state:(NSString *)state successHandler:(void (^)(QUQiviconSmartHomeDevice *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Set state %@ for %@", state, [qiviconSmartHomeDeviceID stringValue]);

	NSString *endpoint = [QUAPIEndpointQiviconSmartHomeDeviceSetState stringByReplacingOccurrencesOfString:@":qiviconSmartHomeDeviceID" withString:[qiviconSmartHomeDeviceID stringValue]];

	[[PFRESTManager sharedManager].operationManager POST:endpoint
											  parameters:@{@"state":state}
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 QUQiviconSmartHomeDevice *qiviconSmartHomeDevice = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];

		 DLOG(@"Success!");
		 successHandler(qiviconSmartHomeDevice);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

@end