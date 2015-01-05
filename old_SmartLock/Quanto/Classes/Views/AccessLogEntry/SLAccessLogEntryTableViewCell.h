//
//  SLAccessLogEntryTableViewCell.h
//  Quanto
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAccessLogEntry.h"

@interface SLAccessLogEntryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;

@property (nonatomic, retain) SLAccessLogEntry *accessLogEntry;

- (void)updateInformation;

@end
