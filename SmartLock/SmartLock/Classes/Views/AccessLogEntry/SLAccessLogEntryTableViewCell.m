//
//  SLAccessLogEntryTableViewCell.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLAccessLogEntryTableViewCell.h"
#import "SLUserProfileManager.h"
#import "SLRESTManager.h"
#import "UIView+SLRound.h"
#import "SLLock+SLUtils.h"

@implementation SLAccessLogEntryTableViewCell

- (void)setAccessLogEntry:(SLAccessLogEntry *)accessLogEntry
{
	_accessLogEntry = accessLogEntry;

	[self updateInformation];
}

- (void)updateInformation
{
    [self.avatarImageView makeRoundWithColor:[UIColor blackColor] borderWidth:1.0f];
    
	if (self.accessLogEntry.user) {
		if (self.accessLogEntry.user.userProfile) {
            NSLog(@"found a user profile ...");

			if (self.accessLogEntry.user.userProfile.avatarURL) {
				if (self.accessLogEntry.user.userProfile.avatarImageData) {
					self.avatarImageView.image = [UIImage imageWithData:self.accessLogEntry.user.userProfile.avatarImageData];
				} else {
//					[self downloadAvatarForUserProfile:self.accessLogEntry.user.userProfile withCompletionHandler:^(NSData *imageData) {
//						 self.avatarImageView.image = [UIImage imageWithData:self.accessLogEntry.user.userProfile.avatarImageData];
//					 }];
                    NSLog(@"Would download avatar...");
				}
			} else {
				NSLog(@"User has no avatar!");
			}
		} else {
			/*[[SLUserProfileManager sharedManager] fetchUserProfileWithUserProfileID:self.accessLogEntry.user.userProfileID completionHandler:^(NSError *error, SLUserProfile *userProfile) {
				 if (error) {
					 NSLog(@"Error: %@", error);
				 } else {
					 [self updateInformation];
				 }
			 }];*/
            NSLog(@"Would Fetch now ...");
		}
	} else {
		NSLog(@"No user found?!?");
	}
    
	self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", self.accessLogEntry.user.lastName, self.accessLogEntry.user.firstName];
	self.actionLabel.text = [NSString stringWithFormat:@"%@ %@", self.accessLogEntry.action, self.accessLogEntry.lock.name];
}

@end
