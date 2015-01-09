//
//  QUOrdersTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrdersTableViewController.h"
#import "QUOrder.h"
#import "PFCoreDataManager.h"
#import "QUGuestManager.h"
#import "QUOrderManager.h"
#import "QUOrderTableViewCell.h"
#import "QUOrder+QUUtils.h"

@interface QUOrdersTableViewController ()

@property (nonatomic, retain) NSTimer *reloadOrdersTimer;

@end

@implementation QUOrdersTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QUOrder class])];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"status" ascending:NO];
	fetchRequest.sortDescriptors = @[descriptor];

	// Setup fetched results
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:[PFCoreDataManager sharedManager].managedObjectContext
																		  sectionNameKeyPath:@"status"
																				   cacheName:nil];
	// Pull to refresh
	self.refreshControl = [UIRefreshControl new];
	self.refreshControl.backgroundColor = [UIColor clearColor];
	self.refreshControl.tintColor = [UIColor darkerDarkGrayColor];
	[self.refreshControl addTarget:self
							action:@selector(reloadOrders)
				  forControlEvents:UIControlEventValueChanged];
    
    [self performSelector:@selector(reloadOrders) withObject:nil afterDelay:0.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.reloadOrdersTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reloadOrders) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.reloadOrdersTimer invalidate];
    self.reloadOrdersTimer = nil;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Reload Orders

- (void)reloadOrders
{
    if ([QUGuestManager isCurrentGuestLoggedIn]) {
        [QUOrderManager synchronizeAllMyOrdersWithSuccessHandler:^(NSSet *orders) {
            [self.refreshControl endRefreshing];
        } failureHandler:^(NSError *error) {
            [self.refreshControl endRefreshing];
        }];
    }
}

#pragma mark - <UITableViewDataSource>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QUOrder *order = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    return [order statusAsString];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

	header.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:20.0f];
	header.textLabel.textColor = [UIColor darkerDarkGrayColor];
	header.textLabel.frame = header.frame;
	header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QUOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUOrderTableViewCellID" forIndexPath:indexPath];

	cell.order = [self.fetchedResultsController objectAtIndexPath:indexPath];

	return cell;
}

#pragma mark - <UITableViewDelegate>
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	QUHotelServiceDetailsViewController *hotelServiceDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QUHotelServiceDetailsViewControllerID"];

	MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:hotelServiceDetailsViewController];
	formSheet.shouldDismissOnBackgroundViewTap = YES;
	formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
	formSheet.cornerRadius = 8.0f;
	formSheet.portraitTopInset = 50.0f;

	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	formSheet.presentedFormSheetSize = CGSizeMake(screenWidth*0.8f, screenHeight*0.8f);
	formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
		presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
		hotelServiceDetailsViewController.service = [self serviceForIndexPath:indexPath];
	};

	[formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
	 }];
}*/

#pragma mark - IBActions


@end