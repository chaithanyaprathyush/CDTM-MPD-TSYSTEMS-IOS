//
//  SLUserProfileManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUserProfileManager.h"
#import "SLRESTManager.h"

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

- (void)fetchUserProfileForUser:(SLUser *)user completionHandler:(void (^)(NSError *, SLUserProfile *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointUserProfile stringByReplacingOccurrencesOfString:@":ID" withString:[user.userID stringValue]];

	[[SLRESTManager sharedManager].objectManager getObjectsAtPath:endpoint
													   parameters:nil
														  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		 completionHandler(nil, mappingResult.firstObject);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

@end
