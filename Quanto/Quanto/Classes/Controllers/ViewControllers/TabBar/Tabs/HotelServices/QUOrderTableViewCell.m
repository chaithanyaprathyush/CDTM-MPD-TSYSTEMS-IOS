//
//  QUOrderTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrderTableViewCell.h"
#import "QUService+QUUtils.h"
#import "QUOrder+QUUtils.h"
#import "NSDate+QUPrettify.h"

@implementation QUOrderTableViewCell

- (void)setOrder:(QUOrder *)order
{
    _order = order;
    
    self.textLabel.text = order.service.name;
    self.detailTextLabel.text = [[order lastModifiedAt] asHHMM];
}

@end