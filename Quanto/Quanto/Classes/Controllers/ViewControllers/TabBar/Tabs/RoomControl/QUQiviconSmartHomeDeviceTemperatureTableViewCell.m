//
//  QUQiviconSmartHomeDeviceTemperatureTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUQiviconSmartHomeDeviceTemperatureTableViewCell.h"
#import "QUQiviconSmartHomeDeviceManager.h"

@implementation QUQiviconSmartHomeDeviceTemperatureTableViewCell

- (void)setQiviconSmartHomeDevice:(QUQiviconSmartHomeDevice *)qiviconSmartHomeDevice
{
    [super setQiviconSmartHomeDevice:qiviconSmartHomeDevice];
    
    self.temperatureStepper.value = [self.qiviconSmartHomeDevice.state floatValue];
    self.nameLabel.text = [NSString stringWithFormat:@"%@: %.1f °", self.qiviconSmartHomeDevice.name, [self.qiviconSmartHomeDevice.state floatValue]];
}

- (void)updateUI
{
    DLOG(@"Update with temp: %@", self.qiviconSmartHomeDevice.state);

	self.temperatureStepper.value = [self.qiviconSmartHomeDevice.state floatValue];

	self.nameLabel.text = [NSString stringWithFormat:@"%@: %.1f °", self.qiviconSmartHomeDevice.name, [self.qiviconSmartHomeDevice.state floatValue]];
}

- (IBAction)didChangeTemperatureStepperValue:(id)sender
{
    NSString *newState = [NSString stringWithFormat:@"%.1f", self.temperatureStepper.value];
    
    [QUQiviconSmartHomeDeviceManager setStateForQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:self.qiviconSmartHomeDevice.qiviconSmartHomeDeviceID
                                                                                             state:newState
                                                                                    successHandler:^(QUQiviconSmartHomeDevice *qiviconSmartHomeDevice) {
        [self updateUI];
    } failureHandler:^(NSError *error) {
        [self updateUI];
    }];
}

@end
