//
//  SLLoginVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLoginVC.h"
#import "SLUserManager.h"

@implementation SLLoginVC

+ (void)showWithViewController:(UIViewController *)viewController completionHandler:(void (^)(void))completionHandler
{
	BOOL isAutoLoginEnabled = YES;

	if (isAutoLoginEnabled) {
		[SLUserManager logInWithStoredCredentialsWithCompletionHandler:^(NSError *error, SLUser *user) {
			 if (error) {
				 SLLoginVC *loginVC = [[UIStoryboard storyboardWithName:@"Main"
																 bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SLLoginVCID"];
				 loginVC.completionHandler = completionHandler;

				 [viewController presentViewController:loginVC animated:YES completion:nil];
			 } else {
				 completionHandler();
			 }
		 }];
	} else {
		SLLoginVC *loginVC = [[UIStoryboard storyboardWithName:@"Main"
														bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SLLoginVCID"];
		loginVC.completionHandler = completionHandler;

		[viewController presentViewController:loginVC animated:YES completion:nil];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.usernameTextField.text = [SLUserManager storedUsername];
	self.passwordTextField.text = [SLUserManager storedPassword];
}

- (void)login
{
	[SLUserManager logInWithUsername:self.usernameTextField.text
							password:self.passwordTextField.text
		   storeCredentialsOnSuccess:YES
				   completionHandler:^(NSError *error, SLUser *user) {
		 if (error) {
			 NSLog(@"error: %@", error);
		 } else {
			 [self.presentingViewController dismissViewControllerAnimated:YES completion:self.completionHandler];
		 }
	 }];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];

	if (textField == self.usernameTextField) {
		[self.passwordTextField becomeFirstResponder];
	} else {
		[self login];
	}

	return YES;
}

#pragma mark - IBActions

- (IBAction)didTouchLoginButton
{
	[self login];
}

@end
