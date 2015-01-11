//
//  QUComplaintsTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 08.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUComplaintsTableViewController.h"
#import "QUGuestManager.h"
#import "QUComplaintManager.h"
#import "QULoginViewController.h"
#import "QUComplaint+QUUtils.h"
#import "QUComplaintTableViewCell.h"
#import "MBProgressHUD+QUUtils.h"

@interface QUComplaintsTableViewController ()

@property (nonatomic, retain) NSTimer *reloadEntitiesTimer;

@end

@implementation QUComplaintsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[super createFetchedResultsControllerWithClass:[QUComplaint class]
									 descriptorKey:@"lastModifiedAt"
										 ascending:NO
								sectionNameKeyPath:@"lastModifiedAtDateOnly"];

	[self enablePullToRefresh];

	super.reloadEntitiesInterval = 10.0f;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Reload Entities

- (void)reloadEntities
{
	if ([QUGuestManager isCurrentGuestLoggedIn]) {
		[QUComplaintManager synchronizeAllMyComplaintsWithSuccessHandler:^(NSSet *complaints) {
			 [self.refreshControl endRefreshing];
		 } failureHandler:^(NSError *error) {
			 [self.refreshControl endRefreshing];
		 }];
	} else {
		[QULoginViewController showWithPresentingViewController:self successHandler:^(QUGuest *guest) {
			 [self reloadEntities];
		 } failureHandler:^(NSError *error) {
			 [self reloadEntities];
		 }];
	}
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRowsInSection = [super tableView:tableView numberOfRowsInSection:section];

	return numberOfRowsInSection;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

	header.textLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];
	header.textLabel.textColor = [UIColor darkerDarkGrayColor];
	header.textLabel.frame = header.frame;
	header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QUComplaintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUComplaintTableViewCellID" forIndexPath:indexPath];

	QUComplaint *complaint = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.complaint = complaint;

	return cell;
}

#pragma mark - <UITableViewDelegate>

#pragma mark - <UITableViewDelegate>

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewRowAction *cancelButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
																			title:@"Cancel"
																		  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
											  QUComplaint *complaint = [self.fetchedResultsController objectAtIndexPath:indexPath];

											  MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
											  progressHUD.labelFont = [UIFont fontWithName:@"Montserrat-Regular" size:30.0f];
											  progressHUD.detailsLabelFont = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];

	                                          // progressHUD.labelColor = [UIColor darkerDarkGrayColor];
	                                          // progressHUD.detailsLabelColor = [UIColor darkerDarkGrayColor];


											  progressHUD.detailsLabelText = @"Deleting complaint...";

											  [QUComplaintManager deleteComplaintWithComplaintID:complaint.complaintID successHandler:^{
												   progressHUD.labelText = @"Done!";
												   progressHUD.detailsLabelText = @"";
												   [progressHUD showCheckmark];
												   [progressHUD hide:YES afterDelay:0.5f];
											   } failureHandler:^(NSError *error) {
												   [progressHUD showCross];
												   progressHUD.detailsLabelText = [error localizedDescription];
												   [progressHUD hide:YES afterDelay:3.0f];
											   }];
										  }];

	cancelButton.backgroundColor = [UIColor peterRiverColor];

	return @[cancelButton];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// needed for cell to be editable
	}
}

@end
