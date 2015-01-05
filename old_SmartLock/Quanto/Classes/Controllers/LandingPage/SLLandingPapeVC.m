//
//  SLLandingPapeVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 07.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLandingPapeVC.h"
#import "UIView+SLRound.h"
#import "SLEnableBluetoothVC.h"

@implementation SLLandingPapeVC

#pragma mark - UIViewController

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	[self.openButton makeRound];
}

#pragma mark - Utils

- (void)showUnlockManualVC
{
	[SLEnableBluetoothVC showWithViewController:self completionHandler:^{
		 NSLog(@"Completed!");
	 }];
}

#pragma mark - IBActions

- (IBAction)didTouchOpenButton
{
	[self showUnlockManualVC];
}

@end
