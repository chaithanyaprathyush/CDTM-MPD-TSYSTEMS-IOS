//
//  QUCreateComplaintViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QUCreateComplaintViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)didTouchCancelButton:(id)sender;
- (IBAction)didTouchTakePictureButton:(id)sender;
- (IBAction)didTouchSendButton:(id)sender;

@end
