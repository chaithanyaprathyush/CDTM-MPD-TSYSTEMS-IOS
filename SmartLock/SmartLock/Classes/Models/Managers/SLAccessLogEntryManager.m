//
//  SLAccessLogEntryManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLAccessLogEntryManager.h"
#import "SLRESTManager.h"
#import "SLUserManager.h"
#import "SLLockManager.h"

@implementation SLAccessLogEntryManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [SLAccessLogEntry class];
}

+ (NSString *)entityIDKey
{
	return @"accessLogEntryID";
}

+ (SLAccessLogEntry *)updateOrCreateEntityWithJSON:(NSDictionary *)JSON
{
	NSNumber *accessLogEntryID = JSON[@"id"];

	SLAccessLogEntry *accessLogEntry = [self fetchOrCreateEntityWithEntityID:accessLogEntryID];

	accessLogEntry.user = [SLUserManager fetchOrCreateEntityWithEntityID:JSON[@"user"]];
	accessLogEntry.lock = [SLLockManager fetchOrCreateEntityWithEntityID:JSON[@"key"]];
    accessLogEntry.action = JSON[@"action"];

	[[SLCoreDataManager sharedManager] save];

	return accessLogEntry;
}

#pragma mark - REST-API

+ (void)synchronizeAccessLogEntryWithAccessLogEntryID:(NSNumber *)accessLogEntryID completionHandler:(void (^)(NSError *, SLAccessLogEntry *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointAccessLogEntry stringByReplacingOccurrencesOfString:@":accessLogEntryID" withString:[accessLogEntryID stringValue]];

	[[SLRESTManager sharedManager].operationManager GET:endpoint
											 parameters:nil
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 SLAccessLogEntry *accessLogEntryID = [self updateOrCreateEntityWithJSON:responseObject];
		 completionHandler(nil, accessLogEntryID);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 NSLog(@"error: %@", error);
		 completionHandler(error, nil);
	 }];
}

+ (void)synchronizeAllAccessLogEntriesWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
	[[SLRESTManager sharedManager].operationManager GET:SLAPIEndpointAccessLogEntries
											 parameters:nil
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 NSArray *accessLogEntries = [self updateOrCreateEntitiesWithJSON:responseObject[@"results"]];
		 completionHandler(nil, accessLogEntries);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

@end
