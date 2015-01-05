//
//  QURegisterViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "QURegisterViewController.h"
#import "MBProgressHUD+QUUtils.h"
#import "QULoginViewController.h"
#import "QUGuestManager.h"
#import "PFAuthenticationManager.h"

@interface QURegisterViewController () <UIAlertViewDelegate>

@end

@implementation QURegisterViewController

+ (void)showWithPresentingViewController:(UIViewController *)presentingViewController successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[self showWithPresentingViewController:presentingViewController successHandler:successHandler failureHandler:failureHandler useStoredCredentials:YES];
}

+ (void)showWithPresentingViewController:(UIViewController *)presentingViewController successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler useStoredCredentials:(BOOL)useStoredCredentials
{
	if (useStoredCredentials) {
		[PFAuthenticationManager authenticateWithStoredCredentialsWithSuccessHandler:^{
			 [QUGuestManager synchronizeGuestWithSuccessHandler:^(QUGuest *guest) {
				  successHandler(guest);
			  } failureHandler:^(NSError *error) {
				  [self showWithPresentingViewController:presentingViewController successHandler:successHandler failureHandler:failureHandler useStoredCredentials:NO];
			  }];
		 } failureHandler:^(NSError *error) {
			 [self showWithPresentingViewController:presentingViewController successHandler:successHandler failureHandler:failureHandler useStoredCredentials:NO];
		 }];
	} else {
		QURegisterViewController *registerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QURegisterViewControllerID"];

		registerViewController.successHandler = successHandler;
		registerViewController.failureHandler = failureHandler;

        
        
		[presentingViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:registerViewController]
											   animated:YES
											 completion:nil];
	}
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	// dismiss keyboard on empty space presses
	UIGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
	tapper.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:tapper];

	self.firstNameTextField.text = [QURegisterViewController randomStringWithLength:10];
	self.lastNameTextField.text = [QURegisterViewController randomStringWithLength:10];
	self.usernameTextField.text = [QURegisterViewController randomStringWithLength:10];
	self.passwordTextField.text = [QURegisterViewController randomStringWithLength:10];
	self.emailTextField.text = [[QURegisterViewController randomStringWithLength:10] stringByAppendingString:@"@web.de"];
}

- (void)registerUser
{
	if (self.firstNameTextField.text.length > 0 && self.lastNameTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0 ) {
		MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
		progressHUD.labelText = @"Registering you...";

		[QUGuestManager createGuestWithUsername:self.usernameTextField.text
									   password:self.passwordTextField.text
										  email:self.emailTextField.text
									  firstName:self.firstNameTextField.text
									   lastName:self.lastNameTextField.text
								 successHandler:^(QUGuest *guest) {
			 progressHUD.progress = 0.5f;
			 progressHUD.labelText = @"Logging you in ...";
			 [PFAuthenticationManager authenticateWithUsername:self.usernameTextField.text
													  password:self.passwordTextField.text
									 storeCredentialsOnSuccess:YES
												successHandler:^{
				  [QUGuestManager synchronizeGuestWithSuccessHandler:^(QUGuest *guest) {
					   [self dismissWithCompletionHandler:^{
							self.successHandler(guest);
						}];
				   } failureHandler:^(NSError *error) {
					   [self dismissWithCompletionHandler:^{
							self.failureHandler(error);
						}];
				   }];
			  } failureHandler:^(NSError *error) {
				  [progressHUD hide:YES];
				  self.registerButton.enabled = YES;

				  [[[UIAlertView alloc] initWithTitle:@"Error"
											  message:@"We're sorry but we couldn't log you in... Please try again later :)"
											 delegate:self
									cancelButtonTitle:@"Okay"
									otherButtonTitles:nil]
				   show];
			  }];
		 } failureHandler:^(NSError *error) {
			 [[[UIAlertView alloc] initWithTitle:@"Error"
										 message:@"We're sorry but we couldn't register you. Please try again later :)"
										delegate:self
							   cancelButtonTitle:@"Okay"
							   otherButtonTitles:nil]
			  show];
			 [progressHUD hide:YES];
			 self.registerButton.enabled = YES;
		 }];
	}
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self dismissWithCompletionHandler:^{
		 self.successHandler([QUGuestManager sharedManager].currentGuest);
	 }];
}

#pragma mark - IBActions

- (IBAction)didTouchCancelButton:(id)sender
{
	[self dismissWithCompletionHandler:^{
		 self.failureHandler(nil);
	 }];
}

- (IBAction)didTouchRegisterButton:(id)sender
{
	[self registerUser];
}

- (IBAction)didTouchShowLoginViewControllerButton
{
	[self dismissAndShowLoginViewController];
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

- (void)dismissAndShowLoginViewController
{
    UIViewController *presentingViewController = self.presentingViewController;

	[self.presentingViewController dismissViewControllerAnimated:YES completion:^{
		 [QULoginViewController showWithPresentingViewController:presentingViewController
												  successHandler:self.successHandler
												  failureHandler:self.failureHandler];
	 }];
}

+ (NSString *)randomStringWithLength:(int)length
{
	NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

	NSMutableString *randomString = [NSMutableString stringWithCapacity:length];

	for (int i=0; i<length; i++) {
		[randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
	}

	return randomString;
}

@end
