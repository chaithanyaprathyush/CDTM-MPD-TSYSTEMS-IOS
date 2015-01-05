//
//  QURoomControlViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QURoomControlViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *bedroomLightButton;
@property (weak, nonatomic) IBOutlet UIButton *bathroomLightButton;
@property (weak, nonatomic) IBOutlet UIButton *roomTemperatureButton;
@property (weak, nonatomic) IBOutlet UIButton *turnOffAllButton;

- (IBAction)didTouchBedroomLightButton:(id)sender;
- (IBAction)didTouchBathroomLightButton:(id)sender;
- (IBAction)didTouchRoomTemperatureButton:(id)sender;
- (IBAction)didTouchTurnOffAllButton:(id)sender;

@end
