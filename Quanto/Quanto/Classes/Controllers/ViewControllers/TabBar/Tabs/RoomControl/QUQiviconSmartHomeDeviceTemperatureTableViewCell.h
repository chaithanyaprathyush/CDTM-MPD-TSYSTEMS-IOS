//
//  QUQiviconSmartHomeDeviceTemperatureTableViewCell.h
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUQiviconSmartHomeDeviceTableViewCell.h"

@interface QUQiviconSmartHomeDeviceTemperatureTableViewCell : QUQiviconSmartHomeDeviceTableViewCell

@property (weak, nonatomic) IBOutlet UIStepper *temperatureStepper;
- (IBAction)didChangeTemperatureStepperValue:(id)sender;

@end
