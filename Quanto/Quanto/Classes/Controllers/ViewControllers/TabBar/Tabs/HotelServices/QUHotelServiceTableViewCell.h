//
//  QUHotelServiceTableViewCell.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUService.h"

@interface QUHotelServiceTableViewCell : UITableViewCell

@property (nonatomic, retain) QUService *service;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
