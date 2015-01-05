//
//  SLHelpVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 08.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLHelpVC.h"
#import "SLEnableBluetoothVC.h"

@implementation SLHelpVC

#pragma mark - Call Reception

- (void)callReception
{
    //TODO: get Phone of hotel (!!)
    
    NSString *phoneNumber = @"telprompt://017656594705";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

#pragma mark - Order Key

- (void)orderKey
{
    
}

#pragma mark - IBActions

- (IBAction)didTouchCallReceptionButton:(id)sender
{
    [self callReception];
}

- (IBAction)didTouchOrderKeyButton:(id)sender
{
    [self orderKey];
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
