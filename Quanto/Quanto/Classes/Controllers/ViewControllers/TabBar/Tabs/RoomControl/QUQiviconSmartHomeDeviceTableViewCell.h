//
//  QUQiviconSmartHomeDeviceTableViewCell.h
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUQiviconSmartHomeDevice.h"

@interface QUQiviconSmartHomeDeviceTableViewCell : UITableViewCell

@property (nonatomic, retain) QUQiviconSmartHomeDevice *qiviconSmartHomeDevice;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@end
