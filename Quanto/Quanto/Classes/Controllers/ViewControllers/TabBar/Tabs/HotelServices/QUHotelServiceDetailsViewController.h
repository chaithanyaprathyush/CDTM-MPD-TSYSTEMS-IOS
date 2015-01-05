//
//  QUHotelServiceDetailsViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUService.h"

@interface QUHotelServiceDetailsViewController : UIViewController

@property (nonatomic, retain) QUService *service;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextTextView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

- (IBAction)didTouchCancelButton:(id)sender;
- (IBAction)didTouchOrderButton:(id)sender;

@end
