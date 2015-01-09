//
//  QUAppDelegate.m
//  Quanto
//
//  Created by Pascal Fritzen on 29.12.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "QUAppDelegate.h"
#import "QUGuestManager.h"
#import "QULoginViewController.h"
#import <MBFingerTipWindow.h>
#import "MZFormSheetController.h"
#import "QUBluetoothManager.h"

@interface QUAppDelegate ()

@end

@implementation QUAppDelegate

- (MBFingerTipWindow *)window
{
	static MBFingerTipWindow *customWindow = nil;

	// Add FingerTip Support for Demonstration
	if (!customWindow) {
		customWindow = [[MBFingerTipWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	}

	return customWindow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Style app

    NSString *headingsFontName = @"Montserrat-Regular";
    NSString *detailsFontName = @"Montserrat-Light";
    
    UIColor *defaultTintColor = [UIColor darkerDarkGrayColor];
    UIColor *defaultBackgroundColor = [UIColor whiteColor];
    
	// Navigation Controller
	[[UINavigationBar appearance] setTintColor:defaultTintColor];
	[[UINavigationBar appearance] setBarTintColor:defaultBackgroundColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:headingsFontName size:25.0f],
														   NSForegroundColorAttributeName:defaultTintColor}];

	// Tab Bar
	[[UITabBar appearance] setTintColor:[UIColor peterRiverColor]];
	[[UITabBar appearance] setBarTintColor:defaultBackgroundColor];
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:headingsFontName size:10.0f]}
											 forState:UIControlStateNormal];
    
    // Bar Button
    [[UIBarButtonItem appearance] setTintColor:[UIColor peterRiverColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:detailsFontName size:20.0f],
                                                           NSForegroundColorAttributeName:[UIColor peterRiverColor]}
                                                forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:detailsFontName size:20.0f],
                                                           NSForegroundColorAttributeName:defaultTintColor}
                                                forState:UIControlStateSelected];
    
    // UISegmentedControl
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:detailsFontName size:15.0f],
                                                              NSForegroundColorAttributeName:[UIColor peterRiverColor]}
                                                   forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:detailsFontName size:15.0f],
                                                              NSForegroundColorAttributeName:defaultBackgroundColor}
                                                   forState:UIControlStateSelected];

	// FormSheets
	[[MZFormSheetController appearance] setCornerRadius:20.0];
	[[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
	[[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    
    // Start BlueTooth
    [QUBluetoothManager sharedManager];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
