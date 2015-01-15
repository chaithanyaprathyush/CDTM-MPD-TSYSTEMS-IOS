//
//  QULoginViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "QULoginViewController.h"
#import "QUGuestManager.h"
#import "PFAuthenticationManager.h"
#import "QURegisterViewController.h"
#import "MBProgressHUD+QUUtils.h"
#import "QUBluetoothManager.h"

@implementation QULoginViewController

+ (void)showWithPresentingViewController:(UIViewController *)presentingViewController successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[self showWithPresentingViewController:presentingViewController successHandler:successHandler failureHandler:failureHandler useStoredCredentials:YES];
}

+ (void)showWithPresentingViewController:(UIViewController *)presentingViewController successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler useStoredCredentials:(BOOL)useStoredCredentials
{
	if (useStoredCredentials) {
		[PFAuthenticationManager authenticateWithStoredCredentialsWithSuccessHandler:^{
			 [QUGuestManager synchronizeGuestWithSuccessHandler:^(QUGuest *guest) {
                 //[QUBluetoothManager didChangeAuthenticationToken:[PFAuthenticationManager storedAuthenticationToken]];
				  successHandler(guest);
			  } failureHandler:^(NSError *error) {
				  [self showWithPresentingViewController:presentingViewController successHandler:successHandler failureHandler:failureHandler useStoredCredentials:NO];
			  }];
		 } failureHandler:^(NSError *error) {
			 [self showWithPresentingViewController:presentingViewController successHandler:successHandler failureHandler:failureHandler useStoredCredentials:NO];
		 }];
	} else {
        QULoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QULoginViewControllerID"];
        
        loginViewController.successHandler = successHandler;
        loginViewController.failureHandler = failureHandler;
        
        [presentingViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:loginViewController]
                                               animated:YES
                                             completion:nil];
	}
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.usernameTextField.text = [PFAuthenticationManager storedUsername] ? : @"pascalfritzen";
	self.passwordTextField.text = [PFAuthenticationManager storedPassword] ? : @"pascalfritzen";

	// dismiss keyboard on empty space presses
	UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
	tapper.cancelsTouchesInView = NO;

	[self.view addGestureRecognizer:tapper];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
}

#pragma mark - Login

- (void)login
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"Logging in...";
    progressHUD.labelFont = [UIFont fontWithName:@"Montserrat-Regular" size:30.0f];
    progressHUD.detailsLabelFont = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];

	[PFAuthenticationManager authenticateWithUsername:self.usernameTextField.text
											 password:self.passwordTextField.text
							storeCredentialsOnSuccess:YES
									   successHandler:^{
		 [QUGuestManager synchronizeGuestWithSuccessHandler:^(QUGuest *guest) {
             progressHUD.labelText = @"Success";
             progressHUD.detailsLabelText = [NSString stringWithFormat:@"Welcome back, %@. %@", guest.salutation, guest.lastName];
             
             [progressHUD showCheckmark];
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [progressHUD hide:YES];
                 
                 [self dismissWithCompletionHandler:^{
                     //[QUBluetoothManager didChangeAuthenticationToken:[PFAuthenticationManager storedAuthenticationToken]];
                     self.successHandler(guest);
                 }];
             });
		  } failureHandler:^(NSError *error) {
              [progressHUD hide:YES];

			  [[[UIAlertView alloc] initWithTitle:@"Error"
										  message:@"We're sorry but we couldn't log you in. Please try again later :)"
										 delegate:self
								cancelButtonTitle:@"Okay"
								otherButtonTitles:nil]
			   show];
		  }];
	 } failureHandler:^(NSError *error) {
         [progressHUD hide:YES];

		 [[[UIAlertView alloc] initWithTitle:@"Error"
									 message:@"We're sorry but we couldn't log you in. Please try again later :)"
									delegate:self
						   cancelButtonTitle:@"Okay"
						   otherButtonTitles:nil]
		  show];
	 }];
}

#pragma mark - IBActions

- (IBAction)didTouchCancelButton:(id)sender
{
	[self dismissWithCompletionHandler:^{
        self.failureHandler(nil);
    }];
}

- (IBAction)didTouchLoginButton:(id)sender
{
	[self login];
}

- (IBAction)didTouchShowRegisterViewControllerButton
{
	[self dismissAndShowRegisterViewController];
}

#pragma mark - Utils

- (void)closeKeyboard:(id)sender
{
	[[self view] endEditing:YES];
}

- (void)dismissWithCompletionHandler:(void (^)(void))completionHandler
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:completionHandler];
}

- (void)dismissAndShowRegisterViewController
{
    UIViewController *presentingViewController = self.presentingViewController;
    
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^{
		 [QURegisterViewController showWithPresentingViewController:presentingViewController
													 successHandler:self.successHandler
													 failureHandler:self.failureHandler];
	 }];
}

@end
