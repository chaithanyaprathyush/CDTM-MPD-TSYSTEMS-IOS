//
//  QUOrderTableViewCell.h
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUOrder.h"

@interface QUOrderTableViewCell : UITableViewCell

@property (nonatomic, retain) QUOrder *order;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
