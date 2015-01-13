//
//  QUQiviconSmartHomeDeviceTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUQiviconSmartHomeDeviceTableViewCell.h"
#import "QUQiviconSmartHomeDeviceManager.h"

@implementation QUQiviconSmartHomeDeviceTableViewCell

- (void)setQiviconSmartHomeDevice:(QUQiviconSmartHomeDevice *)qiviconSmartHomeDevice
{
	_qiviconSmartHomeDevice = qiviconSmartHomeDevice;

	[self updateUI];
}

- (void)updateUI
{
	self.nameLabel.text = self.qiviconSmartHomeDevice.name;

    BOOL isOn = [self.qiviconSmartHomeDevice.state isEqualToString:@"1"];
	
    self.contentView.backgroundColor = isOn ?[UIColor peterRiverColor] :[UIColor whiteColor];
	self.nameLabel.textColor = isOn ?[UIColor whiteColor] :[UIColor darkerDarkGrayColor];
	self.statusImageView.highlighted = isOn;
}

- (UIEdgeInsets)layoutMargins
{
	return UIEdgeInsetsZero;
}

@end
