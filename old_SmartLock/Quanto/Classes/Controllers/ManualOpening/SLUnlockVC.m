//
//  SLUnlockVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 08.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLUnlockVC.h"
#import "SLLockManager.h"
#import "SLEnableBluetoothVC.h"
#import "MBProgressHUD.h"
#import "CWStatusBarNotification+Quanto.h"
#import "SLHelpVC.h"
#import "DVSwitch.h"

@implementation SLUnlockVC

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	DVSwitch *unlockSwitch = [[DVSwitch alloc] initWithStringsArray:@[@"Closed", @"Open"]];

	unlockSwitch.frame = self.lockSwitch.frame;

	unlockSwitch.backgroundColor = self.lockSwitch.backgroundColor;
	unlockSwitch.cornerRadius = 5.0f;
    
	[unlockSwitch setPressedHandler:^(NSUInteger index) {
		 if (index == 1) {
			 [self unlockDoor];
		 }
	 }];

	[unlockSwitch selectIndex:0 animated:NO];

	[self.lockSwitch removeFromSuperview];

	[self.view addSubview:unlockSwitch];

	self.lockSwitch = unlockSwitch;
}

- (void)unlockDoor
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];

	hud.mode = MBProgressHUDModeAnnularDeterminate;
	hud.labelText = @"Fetching all locks ...";

	[hud show:YES];

	[SLLockManager synchronizeAllLocksWithCompletionHandler:^(NSError *error, NSArray *locks) {
		 if (!error && [locks count] >= 1) {
			 hud.progress = 0.5f;
			 hud.labelText = @"Opening locks";

			 [SLLockManager openLock:locks[0] withCompletionHandler:^(NSError *error, SLLock *lock) {
				  NSLog(@"result: %@", lock.status);

				  if ([lock.status isEqualToString:@"OPEN"]) {
					  hud.progress = 1.0f;

					  hud.mode = MBProgressHUDModeCustomView;
					  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];

					  hud.labelText = @"Success";

					  [CWStatusBarNotification displaySuccessNotificationWithText:@"The door was opened successfully!"];
                      
					  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
										 [hud hide:YES];

										 [SLEnableBluetoothVC hideSharedVC];
									 });

					  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
										 [SLLockManager closeLock:locks[0] withCompletionHandler:^(NSError *error, SLLock *lock) {
											  NSLog(@"Lock closed!");
										  }];
									 });
				  } else {
					  [[[UIAlertView alloc] initWithTitle:@"Unlocking failed!"
												  message:@"We're sorry, but the unlocking failed."
												 delegate:self
										cancelButtonTitle:@"Okay"
										otherButtonTitles:nil]
					   show];

					  [self.lockSwitch selectIndex:0 animated:YES];

					  [hud hide:YES];

					  [CWStatusBarNotification displayErrorNotificationWithText:@"Unlocking Door failed!"];

	                  // enable "Next" button somewhere
					  [self performSegueWithIdentifier:@"showHelpVC" sender:self];
				  }
			  }];
		 } else {
			 [self.lockSwitch selectIndex:0 animated:YES];

			 [hud hide:YES];

			 [CWStatusBarNotification displayErrorNotificationWithText:@"Unlocking Door failed!"];

			 [self performSegueWithIdentifier:@"showHelpVC" sender:self];
		 }
	 }];
}

- (void)hide
{
	[SLEnableBluetoothVC hideSharedVC];
}

#pragma mark - IBActions

- (IBAction)didTouchCancelButton:(id)sender
{
	[self hide];
}

@end
