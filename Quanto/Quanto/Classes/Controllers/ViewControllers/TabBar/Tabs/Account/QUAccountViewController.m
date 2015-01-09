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
#import "QUBluetoothManager.h"

@implementation QUAccountViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.loginLogoutButton setTitle:[QUGuestManager isCurrentGuestLoggedIn] ? @"Logout" : @"Login" forState:UIControlStateNormal];

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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.avatarImageView makeRoundWithColor:[UIColor darkerDarkGrayColor] borderWidth:3.0f];
}

#pragma mark - IBActions

- (IBAction)didTouchLoginLogoutButton:(id)sender
{
	if ([QUGuestManager isCurrentGuestLoggedIn]) {
		[QUGuestManager logOutCurrentGuest];

		[PFAuthenticationManager resetStoredCredentials];

		[[PFCoreDataManager sharedManager] resetDatabase];

		// [QUBluetoothManager didChangeAuthenticationToken:nil];

		[self.loginLogoutButton setTitle:@"Login" forState:UIControlStateNormal];
	}

	[QULoginViewController showWithPresentingViewController:self
											 successHandler:^(QUGuest *guest) {
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
