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
#import "SLUser.h"

@implementation SLAccessLogEntryTableViewCell

- (void)setAccessLogEntry:(SLAccessLogEntry *)accessLogEntry
{
	_accessLogEntry = accessLogEntry;

	[self updateInformation];
}

- (void)updateInformation
{
	[self.avatarImageView makeRoundWithColor:[UIColor blackColor] borderWidth:1.0f];

    if (self.accessLogEntry.user.userProfile.avatarImageData) {
        self.avatarImageView.image = [UIImage imageWithData:self.accessLogEntry.user.userProfile.avatarImageData];
    }

	self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", self.accessLogEntry.user.lastName, self.accessLogEntry.user.firstName];
	self.actionLabel.text = [NSString stringWithFormat:@"%@ %@", [self.accessLogEntry.action lowercaseString], self.accessLogEntry.lock.name];
}

@end
