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

@interface QUCreateComplaintViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@end

@implementation QUCreateComplaintViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.sendButton.enabled = NO;
    
    UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self.descriptionTextField action:@selector(resignFirstResponder)];
    tapper.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapper];

	[self showPictureSelection];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
}

#pragma mark - Take Picture

- (void)showPictureSelection
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		self.imagePickerController = [[UIImagePickerController alloc] init];
		self.imagePickerController.delegate = self;
		self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		self.imagePickerController.showsCameraControls = YES;
		self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;

		[self presentViewController:self.imagePickerController animated:NO completion:nil];
	} else {
#if TARGET_IPHONE_SIMULATOR
        self.pictureImageView.image = [UIImage imageNamed:@"room_01"];
#else
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"No camera available!"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
#endif
	}
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
	UIImage *cameraImage = info[UIImagePickerControllerOriginalImage];

	self.pictureImageView.image = cameraImage;

	[self.descriptionTextField becomeFirstResponder];
    
    self.sendButton.enabled = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:NO completion:NULL];

    if (!self.pictureImageView.image) {
		[self dismiss];
	}
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    
    [self createComplaint];

	return YES;
}

#pragma mark - IBActions

- (IBAction)didTouchCancelButton:(id)sender
{
	[self dismiss];
}

- (IBAction)didTouchTakePictureButton:(id)sender
{
	[self showPictureSelection];
}

- (IBAction)didTouchSendButton:(id)sender
{
    [self createComplaint];
}

#pragma mark - Utils

- (void)createComplaint
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.detailsLabelText = @"Sending complaint ...";
    progressHUD.labelFont = [UIFont fontWithName:@"Montserrat-Regular" size:30.0f];
    progressHUD.detailsLabelFont = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];
    
    [QUComplaintManager createComplaintWithPicture:self.pictureImageView.image descriptionText:self.descriptionTextField.text successHandler:^(QUComplaint *complaint) {
        NSLog(@"Succes!!");
        
        [progressHUD showCheckmark];
        progressHUD.detailsLabelText = @"Success! We will take care of your complaint soon.";
        
        [progressHUD hide:YES afterDelay:10.0f completionHandler:^{
            [self dismiss]; 
        }];
    } failureHandler:^(NSError *error) {
        NSLog(@"Fail!");
        
        [progressHUD showCross];
        progressHUD.detailsLabelText = @"Failed to send complaint!";
        //[progressHUD showCheckmark];
        //progressHUD.detailsLabelText = @"Success! We will take care of your complaint very soon.";
        
        [progressHUD hide:YES afterDelay:10.0f completionHandler:^{
            [self dismiss];
        }];
    }];
}

- (void)dismiss
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^{
		 NSLog(@"Hidden again!");
	 }];
}

@end
