//
//  DrawerMenuVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "DrawerRootVC.h"
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerStyler.h>
#import "DrawerMenuVC.h"

@implementation DrawerRootVC

static DrawerRootVC *sharedInstance = nil;

+ (DrawerRootVC *)sharedInstance
{
	return sharedInstance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	sharedInstance = self;

	//	self.paneDragRequiresScreenEdgePan = YES;

	self.menuController = (DrawerMenuVC *)[BaseVC instantiateViewControllerWithIdentifier:@"DrawerMenuVC"];

	[self setDrawerViewController:self.menuController
					 forDirection:MSDynamicsDrawerDirectionLeft];
	self.menuController.drawerRootVC = self;

	self.menuController.menuItems = @[
		@{@"My Locks": [BaseVC instantiateViewControllerInNavigationControllerWithIdentifier:@"LockTVCID"]},
        @{@"Access Log": [BaseVC instantiateViewControllerInNavigationControllerWithIdentifier:@"AccessLogEntryTVCID"]},
/*                       @{@"Favourites":     [BaseViewController instantiateItemCVCInNavigationControllerWithItemStatus:kItemStatusLiked]},
                       @{@"My Offers":      [BaseViewController instantiateItemCVCInNavigationControllerWithItemStatus:kItemStatusOffered]},
                       @{@"My Purchases":   [BaseViewController instantiateItemCVCInNavigationControllerWithItemStatus:kItemStatusPurchased]},
                       @{@"Settings":       [BaseViewController instantiateViewControllerInNavigationControllerWithIdentifier:@"SettingsVC"]},
                       @{@"Logout":         [BaseViewController instantiateViewControllerInNavigationControllerWithIdentifier:@"LogoutVC"]}*/
									];

	[self selectMenuIndex:0];
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
