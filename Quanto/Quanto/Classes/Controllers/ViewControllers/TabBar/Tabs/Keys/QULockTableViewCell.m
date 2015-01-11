//
//  QULockTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QULockTableViewCell.h"
#import "QURoom.h"
#import "QULockManager.h"

@implementation QULockTableViewCell

- (void)setLock:(QULock *)lock
{
	_lock = lock;

	self.roomNumberLabel.text = [NSString stringWithFormat:@"Room No. %i", [lock.room.number intValue]];
	self.lockNameLabel.text = lock.name;

	self.lockStateSegmentedControl.selectedSegmentIndex = [lock.status isEqualToString:@"CLOSED"] ? 0 : 1;
}

- (UIEdgeInsets)layoutMargins
{
	return UIEdgeInsetsZero;
}

- (IBAction)didTouchLockStateSegementedControl:(id)sender
{
	[self.lockingActivitiyIndicator startAnimating];

	switch (self.lockStateSegmentedControl.selectedSegmentIndex) {
	case 0: {
		[QULockManager closeLock:self.lock withSuccessHandler:^(QULock *lock) {
            [self.lockingActivitiyIndicator stopAnimating];

        } failureHandler:^(NSError *error) {
				 self.lockStateSegmentedControl.selectedSegmentIndex = 1;

			 [self.lockingActivitiyIndicator stopAnimating];
		 }];
		break;
	}
	case 1: {
		[QULockManager openLock:self.lock withSuccessHandler:^(QULock *lock) {
            
        } failureHandler:^(NSError *error) {
                self.lockStateSegmentedControl.selectedSegmentIndex = 0;

			 [self.lockingActivitiyIndicator stopAnimating];
		 }];
		break;
	}
	default:
		break;
	}
}

@end
