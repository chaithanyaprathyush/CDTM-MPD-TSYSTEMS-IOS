//
//  QUHotelServicesTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUHotelServicesTableViewController.h"
#import "QUServiceTypeManager.h"
#import "QUServiceManager.h"
#import "QUOrderManager.h"
#import "QUHotelServiceTableViewCell.h"
#import "MZFormSheetController.h"
#import "QUHotelServiceDetailsViewController.h"
#import "QUServiceType.h"
#import "QUOrder+QUUtils.h"
#import "QUOrderTableViewCell.h"
#import "PFCoreDataManager.h"
#import "MBProgressHUD+QUUtils.h"

@interface QUHotelServicesTableViewController ()

@property (nonatomic, retain) NSMutableArray *serviceTypes;

@property (nonatomic, retain) NSTimer *reloadEntitiesTimer;

@end

@implementation QUHotelServicesTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Pull to refresh
	self.refreshControl = [UIRefreshControl new];
	self.refreshControl.backgroundColor = [UIColor clearColor];
	self.refreshControl.tintColor = [UIColor darkerDarkGrayColor];
	[self.refreshControl addTarget:self
							action:@selector(reloadEntities)
				  forControlEvents:UIControlEventValueChanged];

	[self updateFetchedResultsController];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self performSelector:@selector(reloadEntities) withObject:nil afterDelay:0.0f];
	[self updateReloadEntitiesTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[self resetReloadEntitiesTimer];
}

- (void)updateReloadEntitiesTimer
{
	[self resetReloadEntitiesTimer];

	switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
	case 0:
		[self scheduleReloadEntitiesWithTimeInterval:60.0f];
		break;
	case 1:
		[self scheduleReloadEntitiesWithTimeInterval:10.0f];
	default:
		break;
	}
}

- (void)scheduleReloadEntitiesWithTimeInterval:(float)timeInterval
{
	self.reloadEntitiesTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                                target:self
                                                              selector:@selector(reloadEntities)
                                                              userInfo:nil
                                                               repeats:YES];
}

- (void)resetReloadEntitiesTimer
{
	if (self.reloadEntitiesTimer) {
		[self.reloadEntitiesTimer invalidate];
		self.reloadEntitiesTimer = nil;
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Reload Entities

- (void)updateFetchedResultsController
{
	Class entityClassToFetch = nil;
	NSMutableArray *sortDescriptors = [NSMutableArray array];
	NSString *sectionNameKeyPath = nil;

	if (self.servicesOrdersSegmentedControl.selectedSegmentIndex == 0) {
		entityClassToFetch = [QUService class];
		[sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:@"serviceType.name" ascending:YES]];
		sectionNameKeyPath = @"serviceType.name";
	} else {
		entityClassToFetch = [QUOrder class];
		[sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:@"lastModifiedAt" ascending:NO]];
		sectionNameKeyPath = @"lastModifiedAsString";
	}

	self.fetchedResultsController = nil;

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClassToFetch)];
	fetchRequest.sortDescriptors = sortDescriptors;

	// Setup fetched results
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:[PFCoreDataManager sharedManager].managedObjectContext
																		  sectionNameKeyPath:sectionNameKeyPath
																				   cacheName:nil];
}

- (void)reloadEntities
{
	switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
	case 0:
	{
		[QUServiceTypeManager synchronizeAllServiceTypesWithSuccessHandler:^(NSSet *serviceTypes) {
			 [self.refreshControl endRefreshing];
		 } failureHandler:^(NSError *error) {
			 [self.refreshControl endRefreshing];
		 }];
		break;
	}
	case 1:
	{
		[QUOrderManager synchronizeAllMyOrdersWithSuccessHandler:^(NSSet *orders) {
			 [self.refreshControl endRefreshing];
		 } failureHandler:^(NSError *error) {
			 [self.refreshControl endRefreshing];
		 }];
		break;
	}
	default:
		break;
	}
}

#pragma mark - <UITableViewDataSource>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
	case 0:
	{
		QUService *service = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
		return service.serviceType.name;
	}
	case 1:
	{
		QUOrder *order = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
		return [order lastModifiedAsString];
	}
	default:
		return @"";
	}
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

	header.textLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];
	header.textLabel.textColor = [UIColor darkerDarkGrayColor];
	header.textLabel.frame = header.frame;
	header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
	case 0:
		return 160.0f;
	case 1:
		return 60.0f;
	default:
		return 160.0f;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
	case 0:
	{
		QUHotelServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUHotelServiceTableViewCellID" forIndexPath:indexPath];

		cell.service = [self.fetchedResultsController objectAtIndexPath:indexPath];

		return cell;
	}
	case 1:
	{
		QUOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUOrderTableViewCellID" forIndexPath:indexPath];

		cell.order = [self.fetchedResultsController objectAtIndexPath:indexPath];

		return cell;
	}
	default:
		return nil;
	}
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
	case 0:
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
			hotelServiceDetailsViewController.service = [self.fetchedResultsController objectAtIndexPath:indexPath];
		};

		[formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
		 }];
		break;
	}
	default:
		break;
	}

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
	case 0:
		return NO;
	case 1:
		return YES;
	default:
		return NO;
	}
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *cancelButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Cancel" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        QUOrder *order = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
        progressHUD.labelFont = [UIFont fontWithName:@"Montserrat-Regular" size:30.0f];
        progressHUD.detailsLabelFont = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];
        
        //progressHUD.labelColor = [UIColor darkerDarkGrayColor];
        //progressHUD.detailsLabelColor = [UIColor darkerDarkGrayColor];
        
        if ([order.status intValue] != QUOrderStatusOrdered) {
            progressHUD.labelText = @"Not allowed";
            progressHUD.detailsLabelText = @"Sorry for your inconvenience but you already received the service.";
            [progressHUD showCross];
            [progressHUD hide:YES afterDelay:5.0f];
        } else {
            progressHUD.detailsLabelText = @"Cancelling order...";
            
            [QUOrderManager deleteOrderWithOrderID:order.orderID successHandler:^{
                progressHUD.labelText = @"Done!";
                progressHUD.detailsLabelText = @"";
                [progressHUD showCheckmark];
                [progressHUD hide:YES afterDelay:0.5f];
            } failureHandler:^(NSError *error) {
                [progressHUD showCross];
                progressHUD.detailsLabelText = [error localizedDescription];
                [progressHUD hide:YES afterDelay:3.0f];
            }];
        }
    }];
    
    cancelButton.backgroundColor = [UIColor peterRiverColor];
    
    return @[cancelButton];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Cancel";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (self.servicesOrdersSegmentedControl.selectedSegmentIndex) {
            case 1:
            {
                
                break;
            }
            default:
                break;
        }
		//[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	} else {
		NSLog(@"Unhandled editing style! %ld", editingStyle);
	}
}

#pragma mark - IBActions

- (IBAction)didTouchServicesOrdersSegmentedControl:(id)sender
{
	[self updateFetchedResultsController];

	[self reloadEntities];
	[self updateReloadEntitiesTimer];
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}

@end
