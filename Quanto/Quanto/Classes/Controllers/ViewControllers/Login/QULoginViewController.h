//
//  QULoginViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUGuest.h"

@interface QULoginViewController : UIViewController

+ (void)showWithPresentingViewController:(UIViewController *)presentingViewController successHandler:(void (^)(QUGuest *guest))successHandler failureHandler:(void (^)(NSError *error))failureHandler;;

@property (copy) void(^successHandler)(QUGuest *guest);
@property (copy) void(^failureHandler)(NSError *error);

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *showRegisterViewControllerButton;

- (IBAction)didTouchCancelButton:(id)sender;
- (IBAction)didTouchLoginButton:(id)sender;
- (IBAction)didTouchShowRegisterViewControllerButton;

@end
