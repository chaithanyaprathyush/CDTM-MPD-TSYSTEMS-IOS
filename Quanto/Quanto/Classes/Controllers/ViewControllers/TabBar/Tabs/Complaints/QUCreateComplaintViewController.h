//
//  QUCreateComplaintViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QUCreateComplaintViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;

- (IBAction)didTouchCancelButton:(id)sender;
- (IBAction)didTouchTakePictureButton:(id)sender;
- (IBAction)didTouchSendButton:(id)sender;

@end
