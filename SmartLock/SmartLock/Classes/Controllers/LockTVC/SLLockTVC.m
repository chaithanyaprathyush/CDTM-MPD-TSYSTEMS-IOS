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
#import <RestKit/RestKit.h>

@interface SLLockTVC ()

@end

@implementation SLLockTVC

- (void)viewDidLoad
{
	[super viewDidLoad];

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([SLLock class])];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
	fetchRequest.sortDescriptors = @[descriptor];

	// Setup fetched results
	NSError *error = nil;
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"lockCellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	SLLock *lock = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.textLabel.text = lock.name;
	cell.detailTextLabel.text = lock.status;

	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqual:@"showLock"]) {
		SLLockVC *lockVC = segue.destinationViewController;
		lockVC.lock = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
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
