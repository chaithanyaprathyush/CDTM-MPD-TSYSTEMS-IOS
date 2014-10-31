//
//  SLUserProfileManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUserProfileManager.h"
#import "SLRESTManager.h"

static NSString *SLAPIEndpointUserProfiles  = @"user-profiles/";
static NSString *SLAPIEndpointUserProfile   = @"user-profiles/:ID/";

@implementation SLUserProfileManager

#pragma mark - Singleton

+ (SLUserProfileManager *)sharedManager
{
	static SLUserProfileManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
					  sharedManager = [SLUserProfileManager new];
				  });

	return sharedManager;
}

- (instancetype)init
{
	if (self = [super init]) {
		[self initRequestAndResponseDescriptors];
	}
	return self;
}

- (void)initRequestAndResponseDescriptors
{
	self.requestDescriptors = [NSMutableArray array];
	self.responseDescriptors = [NSMutableArray array];

	// Mapping
	RKObjectMapping *userProfileMapping = [RKObjectMapping mappingForClass:[SLUserProfile class]];
	[userProfileMapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"identifier",
		 @"avatar" : @"avatar",
		 @"user" : @"userIdentifier"
	 }];

	[self.responseDescriptors addObject:
	 [RKResponseDescriptor responseDescriptorWithMapping:userProfileMapping
												  method:RKRequestMethodGET
											 pathPattern:SLAPIEndpointUserProfiles
												 keyPath:@"results"
											 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

	[self.responseDescriptors addObject:
	 [RKResponseDescriptor responseDescriptorWithMapping:userProfileMapping
												  method:RKRequestMethodGET
											 pathPattern:SLAPIEndpointUserProfile
												 keyPath:nil
											 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

- (void)fetchUserProfileForUserIdentifier:(NSNumber *)userIdentifier completionHandler:(void (^)(NSError *, SLUserProfile *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointUserProfile stringByReplacingOccurrencesOfString:@":ID" withString:[userIdentifier stringValue]]; // TODO: CHANGE --> GET IDENTIFIER FOR USER PROFILE FROM USER e.g. user.profileIdentifier

	[[SLRESTManager sharedManager].objectManager getObjectsAtPath:endpoint
													   parameters:nil
														  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.firstObject);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

@end
