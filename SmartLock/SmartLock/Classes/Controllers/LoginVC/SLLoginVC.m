//
//  SLLoginVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLoginVC.h"
#import "SLUserManager.h"

@implementation SLLoginVC

+ (void)showWithViewController:(UIViewController *)viewController completionHandler:(void (^)(void))completionHandler
{
    [[SLUserManager sharedManager] logInWithStoredCredentialsWithCompletionHandler:^(NSError *error, SLUser *user) {
        if (error) {
            SLLoginVC *loginVC = [[UIStoryboard storyboardWithName:@"Main"
                                                            bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SLLoginVCID"];
            loginVC.completionHandler = completionHandler;
            
            [viewController presentViewController:loginVC animated:YES completion:nil];
        } else {
            completionHandler();
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.usernameTextField.text = [SLUserManager sharedManager].storedUsername;
    self.passwordTextField.text = [SLUserManager sharedManager].storedPassword;
}

- (void)login
{
    [SLUserManager sharedManager].storedUsername = self.usernameTextField.text;
    [SLUserManager sharedManager].storedPassword = self.passwordTextField.text;
    
	[[SLUserManager sharedManager] logInWithUsername:self.usernameTextField.text
											password:self.passwordTextField.text
								   completionHandler:^(NSError *error, SLUser *user) {
		 if (error) {
			 NSLog(@"error: %@", error);
		 } else {
			 NSLog(@"No error: %@", user);
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

- (IBAction)didTouchLoginButton
{
	[self login];
}

@end
