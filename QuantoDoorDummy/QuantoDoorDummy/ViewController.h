//
//  ViewController.h
//  QuantoDoorDummy
//
//  Created by Pascal Fritzen on 02.01.15.
//  Copyright (c) 2015 Center for Digital Technology and Management. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *scanningActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *startStopScanningButton;
@property (weak, nonatomic) IBOutlet UITextView *peripheralInformationTextView;

- (IBAction)didTouchStartStopScanningButton:(id)sender;
- (IBAction)didTouchResetButton:(id)sender;

@end

