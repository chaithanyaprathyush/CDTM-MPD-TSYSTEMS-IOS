//
//  SLLockVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 26.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLockVC.h"
#import "SLUserManager.h"
#import "SLLockManager.h"
#import "UIView+SLRound.h"
#import "SLLock+SLUtils.h"

@interface SLLockVC ()

@end

@implementation SLLockVC

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLockInformation) userInfo:nil repeats:YES];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	[self.openButton makeRound];
	[self.closeButton makeRound];
    
    [self updateView];
}

- (void)refreshLockInformation
{
    [SLLockManager synchronizeLockWithLockID:self.lock.lockID completionHandler:^(NSError *error, SLLock *lock) {
        self.lock = lock;
        [self updateView];
    }];
}

- (void)updateView
{ 
	self.title = self.lock.name;

	self.openButton.layer.borderWidth = [self.lock isClosed] ? 2.0f : 0.5f;
	self.closeButton.layer.borderWidth = [self.lock isOpen] ? 2.0f : 0.5f;

	self.openButton.enabled = [self.lock isClosed];
	self.closeButton.enabled = [self.lock isOpen];

	self.lockStatusImageView.image = [UIImage imageNamed:[self.lock isOpen] ? @"lock_open" : @"lock_closed"];
}

- (void)openLock
{
	[SLLockManager openLock:self.lock withCompletionHandler:^(NSError *error, SLLock *lock) {
		 if (error) {
			 NSLog(@"error: %@", error);
		 } else {
			 if (lock) {
				 self.lock = lock;

				 [self updateView];
			 }
		 }
	 }];
}

- (void)closeLock
{
	[SLLockManager closeLock:self.lock withCompletionHandler:^(NSError *error, SLLock *lock) {
		 if (error) {
			 NSLog(@"error: %@", error);
		 } else {
			 if (lock) {
				 self.lock = lock;

				 [self updateView];
			 }
		 }
	 }];
}

#pragma mark - IBAction

- (IBAction)didTouchOpenButton:(UIButton *)sender
{
	[self openLock];
}

- (IBAction)didTouchCloseButton:(UIButton *)sender
{
	[self closeLock];
}

@end
