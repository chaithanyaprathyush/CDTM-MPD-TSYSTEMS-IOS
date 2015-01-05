//
//  SLEnableBluetoothVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 07.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLEnableBluetoothVC.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CWStatusBarNotification+Quanto.h"

@interface SLEnableBluetoothVC () <CBCentralManagerDelegate>

@property (copy) void (^completionHandler)(void);

@property (nonatomic, retain) CBCentralManager *bluetoothManager;

@end

@implementation SLEnableBluetoothVC

static SLEnableBluetoothVC *sharedVC = nil;

+ (void)showWithViewController:(UIViewController *)viewController completionHandler:(void (^)(void))completionHandler
{
	SLEnableBluetoothVC *enableBluetoothVC = [[UIStoryboard storyboardWithName:@"Main"
																		bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SLEnableBluetoothVCID"];
	enableBluetoothVC.completionHandler = completionHandler;

	sharedVC = enableBluetoothVC;

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:enableBluetoothVC];

	[viewController presentViewController:navigationController animated:YES completion:nil];
}

+ (void)hideSharedVC
{
	[sharedVC hide];
}

- (void)hide
{
	[sharedVC.presentingViewController dismissViewControllerAnimated:YES completion:sharedVC.completionHandler];
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self detectBluetooth];
    //});

#if TARGET_IPHONE_SIMULATOR
	[self showUnlockVCWithDelay:3.0f];
#endif
}

#pragma mark - IBActions

- (IBAction)didTouchCancelButton:(id)sender
{
	[self hide];
}

#pragma mark - BlueTooth stuff

- (void)detectBluetooth
{
	if (!self.bluetoothManager) {
		// Put on main queue so we can call UIAlertView from delegate callbacks.
		self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
	}
    
	[self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	NSString *stateString = nil;

    self.bluetoothStatusImageView.image = [UIImage imageNamed:@"bluetooth_orange"];

    switch (self.bluetoothManager.state) {
	case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
	case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
	case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy."; break;
	case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off."; break;
	case CBCentralManagerStatePoweredOn: stateString = @"Bluetooth is currently powered on and available to use."; break;
	default: stateString = @"State unknown, update imminent."; break;
	}

//	[CWStatusBarNotification displaySuccessNotificationWithText:stateString];

	NSLog(@"Bluetooth State: %@", stateString);

	if (self.bluetoothManager.state == CBCentralManagerStatePoweredOn) {
//		[CWStatusBarNotification displaySuccessNotificationWithText:stateString];

		[self showUnlockVCWithDelay:0.0f];
	} else if (self.bluetoothManager.state == CBCentralManagerStateUnauthorized || self.bluetoothManager.state == CBCentralManagerStateUnsupported) {
		[CWStatusBarNotification displayErrorNotificationWithText:stateString];
	}
}

- (void)showUnlockVCWithDelay:(float)delay
{
    self.bluetoothStatusImageView.image = [UIImage imageNamed:@"bluetooth_green"];
    
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					   [self performSegueWithIdentifier:@"showUnlockVC" sender:self];
				   });
}

@end
