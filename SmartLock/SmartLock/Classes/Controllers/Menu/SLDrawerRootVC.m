//
//  SLDrawerMenuVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLDrawerRootVC.h"
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerStyler.h>
#import "SLDrawerMenuVC.h"

@implementation SLDrawerRootVC

static SLDrawerRootVC *sharedInstance = nil;

+ (SLDrawerRootVC *)sharedInstance
{
	return sharedInstance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	sharedInstance = self;

	//	self.paneDragRequiresScreenEdgePan = YES;

	self.menuController = (SLDrawerMenuVC *)[SLBaseVC instantiateViewControllerWithIdentifier:@"SLDrawerMenuVC"];

	[self setDrawerViewController:self.menuController
					 forDirection:MSDynamicsDrawerDirectionLeft];
	self.menuController.SLDrawerRootVC = self;

	self.menuController.menuItems = @[
		@{@"My Locks": [SLBaseVC instantiateViewControllerInNavigationControllerWithIdentifier:@"LockTVCID"]},
		@{@"Access Log": [SLBaseVC instantiateViewControllerInNavigationControllerWithIdentifier:@"AccessLogEntryTVCID"]},
/*                       @{@"Favourites":     [BaseViewController instantiateItemCVCInNavigationControllerWithItemStatus:kItemStatusLiked]},
                       @{@"My Offers":      [BaseViewController instantiateItemCVCInNavigationControllerWithItemStatus:kItemStatusOffered]},
                       @{@"My Purchases":   [BaseViewController instantiateItemCVCInNavigationControllerWithItemStatus:kItemStatusPurchased]},
                       @{@"Settings":       [BaseViewController instantiateViewControllerInNavigationControllerWithIdentifier:@"SettingsVC"]},
                       @{@"Logout":         [BaseViewController instantiateViewControllerInNavigationControllerWithIdentifier:@"LogoutVC"]}*/
									];

	[self selectMenuIndex:1];
}

- (void)selectMenuIndex:(int)index
{
	[self.menuController setSelectedControllerIndex:index animated:NO];
}

- (void)showMenu
{
	[self setPaneState:MSDynamicsDrawerPaneStateOpen animated:YES allowUserInterruption:YES completion:^{
		 NSLog(@"Done");
	 }];
}

@end
