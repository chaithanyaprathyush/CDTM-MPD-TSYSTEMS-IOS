//
//  QUKeysViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 01.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUKeysViewController.h"
#import "QUKeyManager.h"
#import "QUGuestManager.h"
#import "QULoginViewController.h"
#import "QULock.h"
#import "QURoom.h"
#import "PFAuthenticationManager.h"

@interface QUKeysViewController ()

@property (nonatomic, retain) NSMutableArray *availableLocks;

@end

@implementation QUKeysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.availableLocks = [NSMutableArray array];
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadUI];
    [self refreshLocks];
}

- (void)refreshLocks
{
	if (![QUGuestManager isCurrentGuestLoggedIn]) {
		[QULoginViewController showWithPresentingViewController:self successHandler:^(QUGuest *guest) {
			 [self refreshLocks];
		 } failureHandler:^(NSError *error) {
			 [self.refreshActivityIndicator stopAnimating];
		 }];
	} else {
        self.roomNumberLabel.text = @"Verifying keys...";
        [self.refreshActivityIndicator startAnimating];
        
        [self.availableLocks removeAllObjects];
        
		[QUKeyManager synchronizeAllMyKeysWithSuccessHandler:^(NSSet *keys) {
		     // DLOG(@"Keys to display: %@", keys);

			 for (QUKey *key in keys) {
				 for (QULock *lock in key.locks) {
					 if (![self.availableLocks containsObject:lock]) {
						 [self.availableLocks addObject:lock];
					 }
				 }
			 }
            
			 [self.refreshActivityIndicator stopAnimating];
			 [self reloadUI];
		 } failureHandler:^(NSError *error) {
             [self reloadUI];
			 [self.refreshActivityIndicator stopAnimating];
			 DLOG(@"Error ... no key to dispaleY!");
		 }];
	}
}

- (void)reloadUI
{
	BOOL currentGuestCanAtLeastOpenOneLock = [self.availableLocks count] >= 1;

    self.roomNumberLabel.hidden = YES;//!currentGuestCanAtLeastOpenOneLock;
	self.noKeysMessageLabel.hidden = currentGuestCanAtLeastOpenOneLock;
	self.openDoorButton.hidden = !currentGuestCanAtLeastOpenOneLock;
	self.refreshButton.hidden = currentGuestCanAtLeastOpenOneLock;

	if (currentGuestCanAtLeastOpenOneLock) {
		QULock *firstLock = self.availableLocks[0];
        
        [self.openDoorButton setTitle:[NSString stringWithFormat:@"Open Room No. %@", firstLock.room.number]
                             forState:UIControlStateNormal];
	}
}

#pragma mark - IBActions

- (IBAction)didTouchOpenDoorButton:(id)sender
{
	DLOG(@"Open Door");
}

- (IBAction)didTouchRefreshButton:(id)sender
{
	[self refreshLocks];
}

@end
