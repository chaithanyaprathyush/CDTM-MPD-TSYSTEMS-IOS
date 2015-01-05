//
//  SLEnableBluetoothVC.h
//  Quanto
//
//  Created by Pascal Fritzen on 07.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLEnableBluetoothVC : UIViewController

+ (void)showWithViewController:(UIViewController *)viewController completionHandler:(void(^)(void))completionHandler;

+ (void)hideSharedVC;

@property (weak, nonatomic) IBOutlet UIImageView *bluetoothStatusImageView;

- (IBAction)didTouchCancelButton:(id)sender;

@end
