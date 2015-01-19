//
//  QURoomManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 01.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QURoomManager.h"
#import "QUStayManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointRooms     = @"rooms/";
static NSString *QUAPIEndpointRoom      = @"rooms/:roomID/";

@implementation QURoomManager

#pragma mark - Singleton

+ (QURoomManager *)sharedManager
{
	static QURoomManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QURoomManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QURoom class];

		self.entityLocalIDKey = @"roomID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QURoom *room = entity;

	if (JSON[@"number"]) {
		room.number = JSON[@"number"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"price"]) {
		room.price = JSON[@"price"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"description"]) {
		room.descriptionText = JSON[@"description"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"picture"]) {
		room.pictureURL = JSON[@"picture"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"stays"]) {
		room.stays = [[QUStayManager sharedManager] updateOrCreateEntitiesWithJSON:JSON[@"stays"]];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
}

#pragma mark - REST-API

+ (void)synchronizeRoomWithRoomID:(NSNumber *)roomID successHandler:(void (^)(QURoom *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointRoom stringByReplacingOccurrencesOfString:@":roomID" withString:[roomID stringValue]];
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllRoomsWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointRooms successHandler:successHandler failureHandler:failureHandler];
}

@end
