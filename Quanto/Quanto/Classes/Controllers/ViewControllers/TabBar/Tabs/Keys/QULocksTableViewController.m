//
//  QULocksTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QULocksTableViewController.h"
#import "QULock.h"
#import "PFCoreDataManager.h"
#import "QUGuestManager.h"
#import "QULockManager.h"
#import "QULockTableViewCell.h"
#import "QUKeyManager.h"
#import "QULoginViewController.h"
#import "QUBluetoothManager.h"

@interface QULocksTableViewController ()

@property (nonatomic, retain) NSTimer *reloadLocksTimer;

@end

@implementation QULocksTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [QUBluetoothManager sharedManager];

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QULock class])];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.number" ascending:YES];
	fetchRequest.sortDescriptors = @[descriptor];

	// Setup fetched results
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:[PFCoreDataManager sharedManager].managedObjectContext
																		  sectionNameKeyPath:nil
                                                                                   cacheName:nil];
	// Pull to refresh
	self.refreshControl = [UIRefreshControl new];
	self.refreshControl.backgroundColor = [UIColor clearColor];
	self.refreshControl.tintColor = [UIColor darkerDarkGrayColor];
	[self.refreshControl addTarget:self
							action:@selector(reloadLocks)
				  forControlEvents:UIControlEventValueChanged];
    
    [self performSelector:@selector(reloadLocks) withObject:nil afterDelay:0.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.reloadLocksTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reloadLocks) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.reloadLocksTimer invalidate];
    self.reloadLocksTimer = nil;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Reload Locks

- (void)reloadLocks
{
    if ([QUGuestManager isCurrentGuestLoggedIn]) {
        [QUKeyManager synchronizeAllMyKeysWithSuccessHandler:^(NSSet *keys) {
            [self.refreshControl endRefreshing];
        } failureHandler:^(NSError *error) {
            [self.refreshControl endRefreshing];
        }];
    } else {
        [QULoginViewController showWithPresentingViewController:self successHandler:^(QUGuest *guest) {
            [self reloadLocks];
        } failureHandler:^(NSError *error) {
            [self reloadLocks];
        }];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = [super tableView:tableView numberOfRowsInSection:section];
    
    self.noKeysMessageLabel.hidden = numberOfRowsInSection >= 1;
    
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QULockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QULockTableViewCellID" forIndexPath:indexPath];

	cell.lock = [self.fetchedResultsController objectAtIndexPath:indexPath];

	return cell;
}


@end