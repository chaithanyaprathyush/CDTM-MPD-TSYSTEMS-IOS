//
//  QURoomViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SevenSwitch/SevenSwitch.h>
#import "DVSwitch.h"

@interface QURoomViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *roomPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *noRoomMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomDetailsLabel;
@property (weak, nonatomic) IBOutlet SevenSwitch *openLockSwitch;
@property (weak, nonatomic) IBOutlet UIView *dvSwitchPlaceholder;
@property (nonatomic, retain) DVSwitch *dvSwitch;

- (IBAction)didTouchOpenLockSwitch:(id)sender;

@end
