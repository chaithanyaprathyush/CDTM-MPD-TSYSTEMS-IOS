//
//  QURoomViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QURoomViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *roomPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *noRoomMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *openDoorButton;

- (IBAction)didTouchOpenDoorButton:(id)sender;

@end
