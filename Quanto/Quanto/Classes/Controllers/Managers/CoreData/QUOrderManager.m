//
//  QUOrderManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrderManager.h"
#import "QURoomManager.h"
#import "QUServiceManager.h"
#import "QUOrder+QUUtils.h"

// REST API Endpoints
static NSString *QUAPIEndpointOrders    = @"orders/";
static NSString *QUAPIEndpointMyOrders  = @"orders/my/";
static NSString *QUAPIEndpointOrder     = @"orders/:orderID/";

@implementation QUOrderManager

#pragma mark - Singleton

+ (QUOrderManager *)sharedManager
{
	static QUOrderManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUOrderManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QUOrder class];

		self.entityLocalIDKey = @"orderID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QUOrder *order = entity;

	if ([JSON hasNonNullStringForKey:@"status"]) {
		order.status = JSON[@"status"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullDateForKey:@"date_created"]) {
		order.createdAt = [JSON dateForKey:@"date_created"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullDateForKey:@"last_modified"]) {
		order.lastModifiedAt = [JSON dateForKey:@"last_modified"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"room"]) {
		order.room = [[QURoomManager sharedManager] fetchOrCreateEntityWithEntityID:JSON[@"room"]];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"service"]) {
		order.service = [[QUServiceManager sharedManager] fetchOrCreateEntityWithEntityID:JSON[@"service"]];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
}

#pragma mark - REST-API

+ (void)createOrderForService:(QUService *)service successHandler:(void (^)(QUOrder *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSDictionary *parameters = @{@"service":service.serviceID};

	DLOG(@"Create Order with parameters: %@", parameters);

	[[PFRESTManager sharedManager].operationManager POST:QUAPIEndpointOrders
											  parameters:parameters
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 QUOrder *order = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];

		 DLOG(@"Success!");
		 successHandler(order);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)synchronizeOrderWithOrderID:(NSNumber *)orderID successHandler:(void (^)(QUOrder *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointOrder stringByReplacingOccurrencesOfString:@":orderID" withString:[orderID stringValue]];
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllMyOrdersWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyOrders successHandler:successHandler failureHandler:failureHandler];
}

+ (void)deleteOrderWithOrderID:(NSNumber *)orderID successHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Delete Order %@", [orderID stringValue]);

	NSString *endpoint = [QUAPIEndpointOrder stringByReplacingOccurrencesOfString:@":orderID" withString:[orderID stringValue]];

	[[PFRESTManager sharedManager].operationManager DELETE:endpoint
												parameters:nil
												   success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 [[PFCoreDataManager sharedManager].managedObjectContext deleteObject:[[self sharedManager] fetchOrCreateEntityWithEntityID:orderID]];
		 [[PFCoreDataManager sharedManager] save];

		 DLOG(@"Success!");
		 successHandler();
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

@end