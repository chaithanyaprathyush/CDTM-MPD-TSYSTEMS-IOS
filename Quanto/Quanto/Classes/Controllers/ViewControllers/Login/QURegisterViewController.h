//
//  QURegisterViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUGuest.h"

@interface QURegisterViewController : UIViewController

+ (void)showWithPresentingViewController:(UIViewController *)presentingViewController successHandler:(void (^)(QUGuest *))successHandler failureHandler:(void (^)(NSError *))failureHandler;

@property (copy) void(^successHandler)(QUGuest *guest);
@property (copy) void(^failureHandler)(NSError *error);

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)didTouchCancelButton:(id)sender;
- (IBAction)didTouchRegisterButton:(id)sender;
- (IBAction)didTouchShowLoginViewControllerButton;

@end
