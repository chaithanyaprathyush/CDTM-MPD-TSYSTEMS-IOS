//
//  QUAccountViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 02.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QUAccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginLogoutButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)didTouchLoginLogoutButton:(id)sender;
- (IBAction)didTouchAvatarImageView:(id)sender;

@end
