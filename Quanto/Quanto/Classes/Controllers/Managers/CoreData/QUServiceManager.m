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

#pragma mark - CoreData

+ (Class)entityClass
{
    return [QUService class];
}

+ (NSString *)entityIDKey
{
    return @"serviceID";
}

+ (void)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
    QUService *service = entity;
    
    service.name = JSON[@"name"];
    service.descriptionText = JSON[@"description"];
    
    if ([JSON hasNonNullStringForKey:@"picture"]) {
        service.pictureURL = JSON[@"picture"];
    }

    service.enabled = JSON[@"enabled"];
    service.price = JSON[@"price"];
    
    // DLOG(@"Updated User Profile with JSON:%@\n%@", JSON, userProfile);
    DLOG(@"Updated QUService %@", service.name);
}

#pragma mark - REST-API

+ (void)synchronizeServiceWithServiceID:(NSNumber *)serviceID successHandler:(void (^)(QUService *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
    NSString *endpoint = [QUAPIEndpointService stringByReplacingOccurrencesOfString:@":serviceID" withString:[serviceID stringValue]];
    [super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllServicesWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
    [super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointServices successHandler:successHandler failureHandler:failureHandler];
}

@end
