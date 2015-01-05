//
//  QULockTableViewCell.h
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QULock.h"

@interface QULockTableViewCell : UITableViewCell

@property (nonatomic, retain) QULock *lock;
@property (weak, nonatomic) IBOutlet UILabel *roomNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockNameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lockStateSegmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *lockingActivitiyIndicator;
- (IBAction)didTouchLockStateSegementedControl:(id)sender;

@end
