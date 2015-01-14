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
    // to be overridden by sub-classes
    [self doesNotRecognizeSelector:_cmd];
}

- (UIEdgeInsets)layoutMargins
{
	return UIEdgeInsetsZero;
}

@end
