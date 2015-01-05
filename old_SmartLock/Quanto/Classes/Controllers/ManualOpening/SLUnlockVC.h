//
//  SLUnlockVC.h
//  Quanto
//
//  Created by Pascal Fritzen on 08.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVSwitch.h"

@interface SLUnlockVC : UIViewController

@property (weak, nonatomic) IBOutlet DVSwitch *lockSwitch;

- (IBAction)didTouchCancelButton:(id)sender;

@end
