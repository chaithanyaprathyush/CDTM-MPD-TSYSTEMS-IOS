//
//  QUAccountViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 02.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUAccountViewController.h"
#import "PFAuthenticationManager.h"
#import "QUGuestManager.h"
#import "QULoginViewController.h"
#import "QUGuest+QUUtils.h"

@implementation QUAccountViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.loginLogoutButton setTitle:[QUGuestManager isCurrentGuestLoggedIn] ? @"Logout" : @"Login" forState:UIControlStateNormal];

	[self.avatarImageView makeRoundWithBorderWidth:5.0f];
	[self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchAvatarImageView:)]];

	if ([QUGuestManager isCurrentGuestLoggedIn]) {
		QUGuest *currentGuest = [QUGuestManager currentGuest];

		[currentGuest downloadAvatarWithSuccessHandler:^{
			 self.avatarImageView.image = [UIImage imageWithData:currentGuest.avatarData];
		 } failureHandler:^(NSError *error) {
		     // TODO: pop question to take a selfie :) // or just use facebook
		 }];

		self.nameLabel.text = [NSString stringWithFormat:@"%@. %@", currentGuest.salutation, currentGuest.lastName];
	}
}

#pragma mark - IBActions

- (IBAction)didTouchLoginLogoutButton:(id)sender
{
	if ([QUGuestManager isCurrentGuestLoggedIn]) {
		[QUGuestManager logOutCurrentGuest];
		[self.loginLogoutButton setTitle:@"Login" forState:UIControlStateNormal];
	}
    
	[QULoginViewController showWithPresentingViewController:self successHandler:^(QUGuest *guest) {
		 DLOG(@"Login Success from Account Tab");
		 [self.loginLogoutButton setTitle:@"Logout" forState:UIControlStateNormal];
	 } failureHandler:^(NSError *error) {
		 DLOG(@"Login Failure from Account Tab");
		 [self.loginLogoutButton setTitle:@"Login" forState:UIControlStateNormal];
	 }];
}

- (void)didTouchAvatarImageView:(id)sender
{
	NSLog(@"hasdf");
}

@end
