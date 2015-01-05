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

@interface QUHotelServicesTableViewController ()

@property (nonatomic, retain) NSMutableArray *serviceTypes;

@end

@implementation QUHotelServicesTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.serviceTypes = [NSMutableArray array];
    
    UISegmentedControl *servicesOrdersSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Services", @"Orders"]];
    [servicesOrdersSegmentedControl sizeToFit];
    
    self.navigationItem.titleView = servicesOrdersSegmentedControl;
}

- (void)viewWillAppear:(BOOL)animated
{
	[QUServiceTypeManager synchronizeAllServiceTypesWithSuccessHandler:^(NSSet *serviceTypes) {
		 [self.serviceTypes removeAllObjects];
		 [self.serviceTypes addObjectsFromArray:[serviceTypes allObjects]];
		 [self.tableView reloadData];
	 } failureHandler:^(NSError *error) {
		 NSLog(@"Error: %@", error);
	 }];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.serviceTypes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath == self.selectedServiceIndexPath) {
	return 160.0f;
//    } else {
//        return 80.0f;
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	QUServiceType *serviceType = self.serviceTypes[section];
	return serviceType.name;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

	header.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:20.0f];
	header.textLabel.textColor = [UIColor goldColor];
	header.textLabel.frame = header.frame;
	header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	QUServiceType *serviceType = self.serviceTypes[section];

	DLOG(@"%lu", (unsigned long)serviceType.services.count);

	return serviceType.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QUHotelServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUHotelServiceTableViewCellID" forIndexPath:indexPath];

	QUService *service = [self serviceForIndexPath:indexPath];

	cell.service = service;

	return cell;
}

#pragma mark - <UITableViewDelegate>

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
}

- (QUService *)serviceForIndexPath:(NSIndexPath *)indexPath
{
	QUServiceType *serviceType = self.serviceTypes[indexPath.section];
	QUService *service = [serviceType.services allObjects][indexPath.row];
	return service;
}

@end
