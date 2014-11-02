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

@interface SLLockTVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

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
    
    [self.fetchedResultsController setDelegate:self];
    self.fetchedResultsController.delegate = self;
    
    BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
    if (!fetchSuccessful) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"SUCCESS: Locks in db: %@", [self.fetchedResultsController fetchedObjects]);
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"#sections: %lu", (unsigned long)[self.fetchedResultsController.sections count]);
	return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"#objects for section %lu: %lu", section, [self.fetchedResultsController.sections[section] numberOfObjects]);
	return [self.fetchedResultsController.sections[section] numberOfObjects];
}

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

#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
