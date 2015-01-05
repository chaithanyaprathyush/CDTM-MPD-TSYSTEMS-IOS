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
static NSString *QUAPIEndpointOrders  = @"orders/";
static NSString *QUAPIEndpointMyOrders  = @"orders/my/";
static NSString *QUAPIEndpointOrder     = @"orders/:orderID/";

@implementation QUOrderManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [QUOrder class];
}

+ (NSString *)entityIDKey
{
	return @"orderID";
}

+ (BOOL)shouldInvokeSimpleUpdate
{
    return NO;
}

+ (BOOL)checkToUpdateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	QUOrder *order = entity;
    BOOL didUpdate = NO;
    
    if (![[order statusAsString] isEqualToString:JSON[@"status"]]) {
        order.status = [NSNumber numberWithInt:[QUOrder statusAsInt:JSON[@"status"]]];
        didUpdate = YES;
    }
    
    if (![order.createdAt isEqualToDate:[JSON dateForKey:@"date_created"]]) {
        order.createdAt = [JSON dateForKey:@"date_created"];
        didUpdate = YES;
    }
    
    if (![order.lastModifiedAt isEqualToDate:[JSON dateForKey:@"last_modified"]]) {
        order.lastModifiedAt = [JSON dateForKey:@"last_modified"];
        didUpdate = YES;
    }
    
    QURoom *room = [QURoomManager fetchOrCreateEntityWithEntityID:JSON[@"room"]];
    if (order.room != room) {
        order.room = room;
        didUpdate = YES;
    }
    
	QUService *service = [QUServiceManager fetchOrCreateEntityWithEntityID:JSON[@"service"]];
    if (order.service != service) {
        order.service = service;
        didUpdate = YES;
    }

	// DLOG(@"Updated User Profile with JSON:%@\n%@", JSON, userProfile);
    if (didUpdate) {
        DLOG(@"Did Update QUOrder %@", order.orderID);
    }
    
    return didUpdate;
}

#pragma mark - REST-API

+ (void)createOrderForService:(QUService *)service successHandler:(void (^)(QUOrder *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSDictionary *parameters = @{@"service":service.serviceID};

	DLOG(@"Create Order with parameters: %@", parameters);

	[[PFRESTManager sharedManager].operationManager POST:QUAPIEndpointOrders
											  parameters:parameters
												 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 QUOrder *order = [self updateOrCreateEntityWithJSON:responseObject];

		 DLOG(@"Successfully created new order: %@", order);

		 successHandler(order);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)synchronizeOrderWithOrderID:(NSNumber *)orderID successHandler:(void (^)(QUOrder *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointOrder stringByReplacingOccurrencesOfString:@":orderID" withString:[orderID stringValue]];
	[super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllMyOrdersWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyOrders successHandler:successHandler failureHandler:failureHandler];
}

@end