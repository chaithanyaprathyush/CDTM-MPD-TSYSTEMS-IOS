//
//  SLAccessLogEntryTVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLAccessLogEntryTVC.h"
#import "SLLoginVC.h"
#import "SLUserManager.h"
#import "SLDrawerRootVC.h"
#import "SLAccessLogEntryManager.h"
#import "SLUserProfileManager.h"
#import "SLAccessLogEntryTableViewCell.h"
#import "SLRESTManager.h"
#import "SLUser.h"
#import "SLLockManager.h"

@implementation SLAccessLogEntryTVC

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([SLAccessLogEntry class])];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[SLCoreDataManager sharedManager].managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)reloadAccessLogEntries
{
	if ([SLUserManager isCurrentUserLoggedIn]) {
        [SLAccessLogEntryManager synchronizeAllAccessLogEntriesWithCompletionHandler:^(NSError *error, NSArray *accessLogEntries) {
			 if (error) {
				 NSLog(@"Error: %@", error);
			 } else {
				 [self.tableView reloadData];
			 }
		 }];
	} else {
		[SLLoginVC showWithViewController:self completionHandler:^{
			 [self reloadAccessLogEntries];
		 }];
	}
}

#pragma mark - <UITableViewDataSource>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"SLAccessLogEntryTableViewCellID";
	SLAccessLogEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	SLAccessLogEntry *accessLogEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.accessLogEntry = accessLogEntry;

	return cell;
}

#pragma mark - IBActions

- (IBAction)didTouchRefreshButton:(id)sender
{
    [self reloadAccessLogEntries];
}

- (IBAction)didTouchMenuButton:(id)sender
{
    [[SLDrawerRootVC sharedInstance] showMenu];
}


@end
