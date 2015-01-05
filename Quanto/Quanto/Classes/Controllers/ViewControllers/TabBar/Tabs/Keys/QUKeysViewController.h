//
//  QUKeysViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 01.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QUKeysViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *openDoorButton;
@property (weak, nonatomic) IBOutlet UILabel *noKeysMessageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

- (IBAction)didTouchOpenDoorButton:(id)sender;
- (IBAction)didTouchRefreshButton:(id)sender;

@end
