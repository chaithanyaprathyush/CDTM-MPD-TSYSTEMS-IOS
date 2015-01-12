//
//  QUStayManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 11.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUStayManager.h"
#import "QUGuestManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointStays    = @"stays/";
static NSString *QUAPIEndpointMyStays  = @"stays/my/";
static NSString *QUAPIEndpointStay     = @"stays/:stayID/";

@implementation QUStayManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [QUStay class];
}

+ (NSString *)entityIDKey
{
	return @"stayID";
}

+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	QUStay *stay = entity;

	stay.fromDate = [JSON dateForKey:@"date_from"];
	stay.toDate = [JSON dateForKey:@"date_to"];
	stay.guests = [QUGuestManager fetchOrCreateEntitiesWithEntityIDs:JSON[@"guests"]];

	// DLOG(@"Updated Stay with JSON:%@\n%@", JSON, stay);
	DLOG(@"Did Update QUStay %@", stay.stayID);
}

#pragma mark - REST-API

+ (void)synchronizeStayWithStayID:(NSNumber *)stayID successHandler:(void (^)(QUStay *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointStay stringByReplacingOccurrencesOfString:@":stayID" withString:[stayID stringValue]];
	[super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllMyStaysWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyStays successHandler:successHandler failureHandler:failureHandler];
}

@end
