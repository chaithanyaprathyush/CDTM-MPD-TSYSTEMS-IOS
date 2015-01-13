//
//  QURoomControlTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 12.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QURoomControlTableViewController.h"
#import "QUQiviconSmartHomeDeviceManager.h"
#import "QUQiviconSmartHomeDeviceTableViewCell.h"

@implementation QURoomControlTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[super createFetchedResultsControllerWithClass:[QUQiviconSmartHomeDevice class]
									 descriptorKey:@"type"
										 ascending:NO
								sectionNameKeyPath:nil];

	[self enablePullToRefresh];

	super.reloadEntitiesInterval = 30.0f;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Reload Entities

- (void)reloadEntities
{
	[QUQiviconSmartHomeDeviceManager synchronizeAllMyQiviconSmartHomeDevicesWithSuccessHandler:^(NSSet *qiviconSmartHomeDevices) {
		 [self.refreshControl endRefreshing];
	 } failureHandler:^(NSError *error) {
		 [self.refreshControl endRefreshing];
	 }];
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QUQiviconSmartHomeDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUQiviconSmartHomeDeviceTableViewCellID" forIndexPath:indexPath];

	QUQiviconSmartHomeDevice *qiviconSmartHomeDevice = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.qiviconSmartHomeDevice = qiviconSmartHomeDevice;

	return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	QUQiviconSmartHomeDevice *qiviconSmartHomeDevice = [self.fetchedResultsController objectAtIndexPath:indexPath];

	if ([qiviconSmartHomeDevice.state isEqualToString:@"0"]) {
		[QUQiviconSmartHomeDeviceManager turnOnQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:qiviconSmartHomeDevice.qiviconSmartHomeDeviceID
																				   successHandler:^(QUQiviconSmartHomeDevice *qiviconSmartHomeDevice) {
		 } failureHandler:^(NSError *error) {
			 DLOG(@"Error!");
		 }];
	} else {
        [QUQiviconSmartHomeDeviceManager turnOffQiviconSmartHomeDeviceWithQiviconSmartHomeDeviceID:qiviconSmartHomeDevice.qiviconSmartHomeDeviceID
																					successHandler:^(QUQiviconSmartHomeDevice *qiviconSmartHomeDevice) {
		 } failureHandler:^(NSError *error) {
			 DLOG(@"Error!");
		 }];
	}
}

@end
