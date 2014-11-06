//
//  SLUserProfileManager.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUserProfileManager.h"
#import "SLRESTManager.h"
#import "SLUserManager.h"

@implementation SLUserProfileManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [SLUserProfile class];
}

+ (NSString *)entityIDKey
{
	return @"userProfileID";
}

+ (SLUserProfile *)updateOrCreateEntityWithJSON:(NSDictionary *)JSON
{
	NSNumber *userProfileID = JSON[@"id"];

	SLUserProfile *userProfile = [self fetchOrCreateEntityWithEntityID:userProfileID];

	userProfile.user = [SLUserManager fetchOrCreateEntityWithEntityID:JSON[@"user"]];
	userProfile.avatarURL = JSON[@"avatar"];

	if (!userProfile.avatarImageData) {
		[self downloadAvatarForUserProfile:userProfile withCompletionHandler:^(NSData *imageData) {
			 userProfile.avatarImageData = imageData;
			 [[SLCoreDataManager sharedManager] save];
		 }];
	}

	[[SLCoreDataManager sharedManager] save];

	return userProfile;
}

#pragma mark - REST-API

+ (void)synchronizeUserProfileWithUserProfileID:(NSNumber *)userProfileID completionHandler:(void (^)(NSError *, SLUserProfile *))completionHandler
{
	NSString *endpoint = [SLAPIEndpointUserProfile stringByReplacingOccurrencesOfString:@":userProfileID" withString:[userProfileID stringValue]];

	[[SLRESTManager sharedManager].operationManager GET:endpoint
											 parameters:nil
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 SLUserProfile *userProfile = [self updateOrCreateEntityWithJSON:responseObject];
		 completionHandler(nil, userProfile);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 NSLog(@"error: %@", error);
		 completionHandler(error, nil);
	 }];
}

+ (void)synchronizeAllUserProfilesWithCompletionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
	[[SLRESTManager sharedManager].operationManager GET:SLAPIEndpointUserProfiles
											 parameters:nil
												success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 NSArray *userProfiles = [self updateOrCreateEntitiesWithJSON:responseObject[@"results"]];
		 completionHandler(nil, userProfiles);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 completionHandler(error, nil);
	 }];
}

+ (void)downloadAvatarForUserProfile:(SLUserProfile *)userProfile withCompletionHandler:(void (^) (NSData *imageData))completionHandler
{
	dispatch_async(dispatch_queue_create("Download Avatar", nil), ^{
					   NSURL *avatarURL = [NSURL URLWithString:[[BASE_URL_STRING stringByReplacingOccurrencesOfString:@"/api/" withString:@"/media/"] stringByAppendingString:userProfile.avatarURL]];
					   NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
					   dispatch_async(dispatch_get_main_queue(), ^{
										  completionHandler(avatarData);
									  });
				   });
}

@end

