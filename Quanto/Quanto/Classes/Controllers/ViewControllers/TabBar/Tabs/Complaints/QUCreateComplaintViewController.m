//
//  QUCreateComplaintViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUCreateComplaintViewController.h"
#import "QUComplaintManager.h"
#import "MBProgressHUD+QUUtils.h"

@interface QUCreateComplaintViewController ()

@property (nonatomic, retain) NSData *pictureData;

@end

@implementation QUCreateComplaintViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.sendButton.enabled = NO;
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
}

#pragma mark - IBActions

- (IBAction)didTouchCancelButton:(id)sender
{
    [self hide];
}

- (IBAction)didTouchTakePictureButton:(id)sender
{
}

- (IBAction)didTouchSendButton:(id)sender
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.detailsLabelText = @"Sending complaint ...";
    
    [QUComplaintManager createComplaintWithPictureData:self.pictureData descriptionText:self.descriptionTextView.text successHandler:^(QUComplaint *complaint) {
        NSLog(@"Succes!!");

        [progressHUD showCheckmark];
        progressHUD.detailsLabelText = @"Success! We will take care of your complaint right now...";
        
        [progressHUD hide:YES afterDelay:3.0f completionHandler:^{
            [self hide];
        }];
    } failureHandler:^(NSError *error) {
        NSLog(@"Fail!");
        
        [progressHUD showCross];
        progressHUD.detailsLabelText = @"Failed to upload complaint!";

        [progressHUD hide:YES afterDelay:3.0f completionHandler:^{
            [self hide];
        }];
    }];
}

#pragma mark - Utils

- (void)hide
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Hidden again!");
    }];
}

@end
