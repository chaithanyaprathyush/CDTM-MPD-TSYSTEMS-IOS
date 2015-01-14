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

	self.pictureImageView.image = [self scaleAndRotateImage:cameraImage];

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

#pragma mark - UIImage Utils

// Code from: http://stackoverflow.com/questions/538041/uiimagepickercontroller-camera-preview-is-portrait-in-landscape-app
- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
	int kMaxResolution = 1080; // Or whatever

	CGImageRef imgRef = image.CGImage;

	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);


	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = roundf(bounds.size.width / ratio);
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = roundf(bounds.size.height * ratio);
		}
	}

	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {

	case UIImageOrientationUp:     // EXIF = 1
		transform = CGAffineTransformIdentity;
		break;

	case UIImageOrientationUpMirrored:     // EXIF = 2
		transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
		transform = CGAffineTransformScale(transform, -1.0, 1.0);
		break;

	case UIImageOrientationDown:     // EXIF = 3
		transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
		transform = CGAffineTransformRotate(transform, M_PI);
		break;

	case UIImageOrientationDownMirrored:     // EXIF = 4
		transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
		transform = CGAffineTransformScale(transform, 1.0, -1.0);
		break;

	case UIImageOrientationLeftMirrored:     // EXIF = 5
		boundHeight = bounds.size.height;
		bounds.size.height = bounds.size.width;
		bounds.size.width = boundHeight;
		transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
		transform = CGAffineTransformScale(transform, -1.0, 1.0);
		transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
		break;

	case UIImageOrientationLeft:     // EXIF = 6
		boundHeight = bounds.size.height;
		bounds.size.height = bounds.size.width;
		bounds.size.width = boundHeight;
		transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
		transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
		break;

	case UIImageOrientationRightMirrored:     // EXIF = 7
		boundHeight = bounds.size.height;
		bounds.size.height = bounds.size.width;
		bounds.size.width = boundHeight;
		transform = CGAffineTransformMakeScale(-1.0, 1.0);
		transform = CGAffineTransformRotate(transform, M_PI / 2.0);
		break;

	case UIImageOrientationRight:     // EXIF = 8
		boundHeight = bounds.size.height;
		bounds.size.height = bounds.size.width;
		bounds.size.width = boundHeight;
		transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
		transform = CGAffineTransformRotate(transform, M_PI / 2.0);
		break;

	default:
		[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

	}

	UIGraphicsBeginImageContext(bounds.size);

	CGContextRef context = UIGraphicsGetCurrentContext();

	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}

	CGContextConcatCTM(context, transform);

	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return imageCopy;
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

		 [progressHUD hide:YES afterDelay:5.0f completionHandler:^{
			  [self dismiss];
		  }];
	 } failureHandler:^(NSError *error) {
		 NSLog(@"Fail!");

		 [progressHUD showCross];
		 progressHUD.detailsLabelText = @"Failed to send complaint!";

		 [progressHUD hide:YES afterDelay:5.0f completionHandler:^{
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
