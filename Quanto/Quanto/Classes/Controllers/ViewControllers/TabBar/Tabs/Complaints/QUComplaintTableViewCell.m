//
//  QUComplaintTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUComplaintTableViewCell.h"

@implementation QUComplaintTableViewCell

- (void)setComplaint:(QUComplaint *)complaint
{
    _complaint = complaint;
    
    self.textLabel.text = complaint.descriptionText;
    self.detailTextLabel.text = complaint.status;
    
    if ([complaint.status isEqual:@"Opened"]) {
        self.detailTextLabel.textColor = [UIColor darkerDarkGrayColor];
    } else {
        self.detailTextLabel.textColor = [UIColor emeraldColor];
    }
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
