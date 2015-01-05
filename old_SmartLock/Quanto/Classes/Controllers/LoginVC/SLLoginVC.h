//
//  SLLoginVC.h
//  Quanto
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLLoginVC : UIViewController <UITextFieldDelegate>

+ (void)showWithViewController:(UIViewController *)viewController completionHandler:(void(^)(void))completionHandler;

@property (copy) void(^completionHandler)(void);

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)didTouchLoginButton;

@end
