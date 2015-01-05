//
//  ViewController.h
//  QIVICONTest
//
//  Created by Pascal Fritzen on 15.11.14.
//  Copyright (c) 2014 CDTM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

- (IBAction)didTouchLoginButton:(id)sender;

@end

