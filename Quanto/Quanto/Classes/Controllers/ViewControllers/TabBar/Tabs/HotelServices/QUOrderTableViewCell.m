//
//  QUOrderTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrderTableViewCell.h"
#import "QUService.h"
#import "QUOrder+QUUtils.h"
#import "NSDate+QUPrettify.h"

@implementation QUOrderTableViewCell

- (void)setOrder:(QUOrder *)order
{
    _order = order;
    
    self.serviceNameLabel.text = order.service.name;
    self.timeLabel.text = [[order lastModifiedAt] asHHMM];
    self.statusLabel.text = [order statusAsString];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
