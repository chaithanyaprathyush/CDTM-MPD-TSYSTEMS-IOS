//
//  SLRESTManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLRESTManager.h"
#import "SLUserManager.h"
#import "SLLockManager.h"
#import "SLAccessLogEntryManager.h"
#import "SLUserProfileManager.h"
#import <RestKit/CoreData.h>

@interface SLRESTManager ()
@end

@implementation SLRESTManager

#pragma mark - Singleton

+ (SLRESTManager *)sharedManager
{
	static SLRESTManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [SLRESTManager new];
				  });

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL_STRING]];

		self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
		self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;

		NSURL *dbSchemaURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SmartLock" ofType:@"momd"]];
		NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:dbSchemaURL] mutableCopy];
		self.objectManager.managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];

		// set log levels
		RKLogConfigureByName("RestKit", RKLogLevelWarning);
		RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
		RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
		RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
		RKLogConfigureByName("RestKit/CoreData/Cache", RKLogLevelTrace);

		[self.objectManager.managedObjectStore createPersistentStoreCoordinator];
		NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"SLDatabase.sqlite"];
		NSError *error;
		NSPersistentStore *persistentStore = [self.objectManager.managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                                                                            fromSeedDatabaseAtPath:nil
                                                                                                 withConfiguration:nil
                                                                                                           options:nil
                                                                                                             error:&error];
		NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);

		// Create the managed object contexts
		[self.objectManager.managedObjectStore createManagedObjectContexts];

		// Configure a managed object cache to ensure we do not create duplicate objects
		self.objectManager.managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:self.objectManager.managedObjectStore.persistentStoreManagedObjectContext];

		// Initialize object mappings
		[self initMappings];
	}

	return self;
}

- (void)initMappings
{
	RKManagedObjectStore *managedObjectStore = self.objectManager.managedObjectStore;

	NSMutableArray *requestDescriptors = [NSMutableArray array];
	NSMutableArray *responseDescriptors = [NSMutableArray array];

	RKEntityMapping *userMapping            = [RKEntityMapping mappingForEntityForName:@"SLUser"            inManagedObjectStore:managedObjectStore];
	RKEntityMapping *userProfileMapping     = [RKEntityMapping mappingForEntityForName:@"SLUserProfile"     inManagedObjectStore:managedObjectStore];
	RKEntityMapping *lockMapping            = [RKEntityMapping mappingForEntityForName:@"SLLock"            inManagedObjectStore:managedObjectStore];
	RKEntityMapping *accessLogEntryMapping  = [RKEntityMapping mappingForEntityForName:@"SLAccessLogEntry"  inManagedObjectStore:managedObjectStore];

	// ************
	// *** USER ***
	// ************

	// Attributes
	[userMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"userID",
		 @"email" : @"email",
		 @"username" : @"username",
		 @"first_name" : @"firstName",
		 @"last_name" : @"lastName",
		 @"date_joined" : @"joinedAt",
		 @"password" : @"password"
	 }];

	// Properties (Relationships)
	/*[userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_profile"
																				toKeyPath:@"userProfile"
																			  withMapping:userProfileMapping]];*/

	/*[userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"access_log_entries"
	                                                                            toKeyPath:@"accessLogEntries"
	                                                                          withMapping:accessLogEntryMapping]];*/
	// ID attribute
	userMapping.identificationAttributes = @[@"userID"];

	// Response Descriptors
	[responseDescriptors addObject:
	 [RKResponseDescriptor responseDescriptorWithMapping:userMapping
												  method:RKRequestMethodGET
											 pathPattern:SLAPIEndpointUsers
												 keyPath:@"results"
											 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	// ********************
	// *** USER PROFILE ***
	// ********************

	// Attributes
	[userProfileMapping addAttributeMappingsFromDictionary:@{
		 @"avatar" : @"avatarURL",
		 @"id" : @"userProfileID",
	 }];

	// Properties (Relationships)
	/*[userProfileMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
																					   toKeyPath:@"user"
																					 withMapping:userMapping]];*/

	// ID attribute
	userProfileMapping.identificationAttributes = @[@"userProfileID"];

	// Response Descriptors
	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:userProfileMapping
																				method:RKRequestMethodGET
																		   pathPattern:SLAPIEndpointUserProfiles
																			   keyPath:@"results"
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:userProfileMapping
																				method:RKRequestMethodGET
																		   pathPattern:SLAPIEndpointUserProfile
																			   keyPath:nil
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	// ************
	// *** LOCK ***
	// ************

	// Attributes
	[lockMapping addAttributeMappingsFromDictionary:@{
		 @"date_created" : @"createdAt",
		 @"last_modified" : @"lastModifiedAt",
		 @"location_lat" : @"locationLat",
		 @"location_lon" : @"locationLon",
		 @"id" : @"lockID",
		 @"name" : @"name",
		 @"status" : @"status",
	 }];

	// Properties (Relationships)
	/*[lockMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"access_log_entries"
	                                                                            toKeyPath:@"accessLogEntries"
	                                                                          withMapping:accessLogEntryMapping]]; */

	// ID attribute
	lockMapping.identificationAttributes = @[@"lockID"];

	// Response Descriptors
	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																				method:RKRequestMethodGET
																		   pathPattern:SLAPIEndpointLocks
																			   keyPath:@"results"
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																				method:RKRequestMethodGET
																		   pathPattern:SLAPIEndpointLocksMy
																			   keyPath:@"results"
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    [responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																				method:RKRequestMethodGET
																		   pathPattern:SLAPIEndpointLock
																			   keyPath:nil
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    /*
	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																				method:RKRequestMethodPOST
																		   pathPattern:SLAPIEndpointLockOpen
																			   keyPath:@"results"
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:lockMapping
																				method:RKRequestMethodPOST
																		   pathPattern:SLAPIEndpointLockClose
																			   keyPath:@"results"
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];*/

	// ************************
	// *** ACCESS LOG ENTRY ***
	// ************************
	// Attributes
	[accessLogEntryMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"accessLogEntryID",
		 @"action" : @"action",
		 @"date_created" : @"createdAt"
	 }];

	// Properties (Relationships)
	/*[accessLogEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
																						  toKeyPath:@"user"
																						withMapping:userMapping]];

	[accessLogEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"lock"
																						  toKeyPath:@"lock"
																						withMapping:lockMapping]];*/

	// ID attribute
	accessLogEntryMapping.identificationAttributes = @[@"accessLogEntryID"];

	// Response Descriptors
	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:accessLogEntryMapping
																				method:RKRequestMethodGET
																		   pathPattern:SLAPIEndpointAccessLogEntries
																			   keyPath:@"results"
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:accessLogEntryMapping
																				method:RKRequestMethodGET
																		   pathPattern:SLAPIEndpointAccessLogEntry
																			   keyPath:@"results"
																		   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	// ************
	// *** DONE ***
	// ************
	[self.objectManager addResponseDescriptorsFromArray:responseDescriptors];
	[self.objectManager addRequestDescriptorsFromArray:requestDescriptors];
}

#pragma mark - Authorization Header

- (BOOL)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password
{
	if (!username || !password || [username isEqualToString:@""] || [password isEqualToString:@""]) {
		[self clearAuthorizationHeader];
		return NO;
	}
    
	[self.objectManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
	return YES;
}

- (void)clearAuthorizationHeader
{
    [self.objectManager.HTTPClient clearAuthorizationHeader];
}

@end
