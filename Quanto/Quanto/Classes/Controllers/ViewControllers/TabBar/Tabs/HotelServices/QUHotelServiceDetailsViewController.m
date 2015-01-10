//
//  QUHotelServiceDetailsViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUHotelServiceDetailsViewController.h"
#import "QUService+QUUtils.h"
#import "MZFormSheetController.h"
#import "MBProgressHUD+QUUtils.h"
#import "QUOrderManager.h"

@implementation QUHotelServiceDetailsViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.descriptionTextTextView.editable = YES;
	self.descriptionTextTextView.textColor = [UIColor darkerDarkGrayColor];
	self.descriptionTextTextView.font = [UIFont fontWithName:@"Montserrat-Light" size:18.0f];
	self.descriptionTextTextView.editable = NO;
}

#pragma mark - Service

- (void)setService:(QUService *)service
{
	_service = service;

	self.nameLabel.text = service.name;
	self.descriptionTextTextView.text = service.descriptionText;
	self.priceLabel.text = [NSString stringWithFormat:@"%.2f €", [service.price floatValue]];

	[service downloadPictureWithSuccessHandler:^{
		 self.pictureImageView.image = [UIImage imageWithData:service.pictureData];
	 } failureHandler:^(NSError *error) {
		 NSLog(@"Fail!");
	 }];
}

#pragma mark - IBActions

- (void)didTouchCancelButton:(id)sender
{
    [self dismiss];
}

- (IBAction)didTouchOrderButton:(id)sender
{
	MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	progressHUD.labelText = @"Ordering Service ...";
    progressHUD.labelFont = [UIFont fontWithName:@"Montserrat-Regular" size:30.0f];
    progressHUD.detailsLabelFont = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];

	[QUOrderManager createOrderForService:self.service successHandler:^(QUOrder *order) {
		 progressHUD.labelText = @"Success!";
		 [progressHUD showCheckmarkAndHide:YES afterDelay:1.0f completionHandler:^{
             [self dismiss];
		  }];
	 } failureHandler:^(NSError *error) {
		 progressHUD.labelText = @"Error";
         [progressHUD showCrossAndHide:YES afterDelay:2.0f completionHandler:^{
             
         }];
	 }];
}

- (void)dismiss
{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

@end
