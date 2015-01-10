//
//  QURoomControlTableViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 10.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QURoomControlTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *bedroomLightsLabel;
@property (weak, nonatomic) IBOutlet UIButton *bedroomLightsButton;

@property (weak, nonatomic) IBOutlet UILabel *bathroomLightsLabel;
@property (weak, nonatomic) IBOutlet UIButton *bathroomLightsButton;

@property (weak, nonatomic) IBOutlet UILabel *livingRoomLightsLabel;
@property (weak, nonatomic) IBOutlet UIButton *livingRoomLightsButton;

@property (weak, nonatomic) IBOutlet UILabel *musicLightsLabel;
@property (weak, nonatomic) IBOutlet UIButton *musicLightsButton;

- (IBAction)didTouchBedroomLightsButton:(id)sender;

@end
