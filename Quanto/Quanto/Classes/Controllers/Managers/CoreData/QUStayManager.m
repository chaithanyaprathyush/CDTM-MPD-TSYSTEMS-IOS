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

#pragma mark - Singleton

+ (QUStayManager *)sharedManager
{
    static QUStayManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [QUStayManager new];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.entityClass = [QUStay class];
        
        self.entityLocalIDKey = @"stayID";
    }
    return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
    BOOL didUpdateAtLeastOneValue = NO;
    
    QUStay *stay = entity;
    
    if ([JSON hasNonNullDateForKey:@"date_from"]) {
        stay.fromDate = [JSON dateForKey:@"date_from"];
        didUpdateAtLeastOneValue = YES;
    }
    
    if ([JSON hasNonNullDateForKey:@"date_to"]) {
        stay.toDate = [JSON dateForKey:@"date_to"];
        didUpdateAtLeastOneValue = YES;
    }
    
    if (JSON[@"guests"]) {
        stay.guests = [[QUGuestManager sharedManager] fetchOrCreateEntitiesWithEntityIDs:JSON[@"guests"]];
        didUpdateAtLeastOneValue = YES;
    }
    
    return didUpdateAtLeastOneValue;
}

#pragma mark - REST-API

+ (void)synchronizeStayWithStayID:(NSNumber *)stayID successHandler:(void (^)(QUStay *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointStay stringByReplacingOccurrencesOfString:@":stayID" withString:[stayID stringValue]];
    [[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllMyStaysWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyStays successHandler:successHandler failureHandler:failureHandler];
}

@end
