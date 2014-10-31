//
//  SLLockTVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLockTVC.h"
#import "SLUserManager.h"
#import "SLLockManager.h"
#import "SLLockVC.h"
#import "SLLoginVC.h"
#import "DrawerRootVC.h"

@interface SLLockTVC ()

@property (nonatomic, retain) NSArray *locks;

@end

@implementation SLLockTVC

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self reloadLocks];
}

- (void)reloadLocks
{
	if ([[SLUserManager sharedManager] isCurrentUserLoggedIn]) {
		[[SLLockManager sharedManager] fetchMyLocksWithCompletionHandler:^(NSError *error, NSArray *locks) {
			 if (error) {
				 NSLog(@"Error: %@", error);
			 } else {
				 self.locks = locks;
				 [self.tableView reloadData];
			 }
		 }];
	} else {
		[SLLoginVC showWithViewController:self completionHandler:^{
			 [self reloadLocks];
		 }];
	}
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.locks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"lockCellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	SLLock *lock = self.locks[indexPath.row];

	cell.textLabel.text = lock.name;
	cell.detailTextLabel.text = lock.status;

	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqual:@"showLock"]) {
		SLLockVC *lockVC = segue.destinationViewController;
		lockVC.lock = self.locks[[self.tableView indexPathForSelectedRow].row];
	}
}

- (IBAction)didTouchRefreshButton:(id)sender
{
	[self reloadLocks];
}

- (IBAction)didTouchMenuButton:(id)sender
{
    [[DrawerRootVC sharedInstance] showMenu];
}

@end
