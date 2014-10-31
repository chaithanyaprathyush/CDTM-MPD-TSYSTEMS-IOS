//
//  SLLockVC.h
//  SmartLock
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLLock.h"

@interface SLLockVC : UIViewController

@property (nonatomic, retain) SLLock *lock;

@property (weak, nonatomic) IBOutlet UIImageView *lockStatusImageView;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)didTouchOpenButton:(UIButton *)sender;
- (IBAction)didTouchCloseButton:(UIButton *)sender;

@end
