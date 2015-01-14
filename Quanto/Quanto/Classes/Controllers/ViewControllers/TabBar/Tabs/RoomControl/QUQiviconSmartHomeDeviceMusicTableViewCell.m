//
//  QUQiviconSmartHomeDeviceMusicTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUQiviconSmartHomeDeviceMusicTableViewCell.h"
#import "QUQiviconSmartHomeDeviceManager.h"

@implementation QUQiviconSmartHomeDeviceMusicTableViewCell

- (void)updateUI
{
	self.nameLabel.text = self.qiviconSmartHomeDevice.name;
}

@end
