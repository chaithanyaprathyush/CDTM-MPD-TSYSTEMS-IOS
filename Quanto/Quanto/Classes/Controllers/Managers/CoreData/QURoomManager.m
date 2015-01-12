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

#pragma mark - CoreData

+ (Class)entityClass
{
    return [QURoom class];
}

+ (NSString *)entityIDKey
{
    return @"roomID";
}

+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
    QURoom *room = entity;
    
    room.number = JSON[@"number"];
    room.price = JSON[@"price"];
    room.descriptionText = JSON[@"description"];

    if ([JSON hasNonNullStringForKey:@"picture"]) {
        room.pictureURL = JSON[@"picture"];
    }
    
    room.stays = [QUStayManager updateOrCreateEntitiesWithJSON:JSON[@"stays"]];
    
    // DLOG(@"Updated User Profile with JSON:%@\n%@", JSON, userProfile);
    DLOG(@"Updated QURoom %@", room.number);
}

#pragma mark - REST-API

+ (void)synchronizeRoomWithRoomID:(NSNumber *)roomID successHandler:(void (^)(QURoom *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
    NSString *endpoint = [QUAPIEndpointRoom stringByReplacingOccurrencesOfString:@":roomID" withString:[roomID stringValue]];
    [super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllRoomsWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
    [super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointRooms successHandler:successHandler failureHandler:failureHandler];
}

@end
