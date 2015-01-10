//
//  QUOrdersTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 10.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrdersTableViewController.h"
#import "QUOrder+QUUtils.h"
#import "QUOrderManager.h"
#import "QUOrderTableViewCell.h"
#import "MBProgressHUD+QUUtils.h"

@interface QUOrdersTableViewController ()

@property (nonatomic, retain) NSTimer *reloadEntitiesTimer;

@end

@implementation QUOrdersTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super createFetchedResultsControllerWithClass:[QUOrder class]
                                     descriptorKey:@"lastModifiedAt"
                                         ascending:NO
                                sectionNameKeyPath:@"lastModifiedAsString"];
    
    [super enablePullToRefresh];
    
    super.reloadEntitiesInterval = 10.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Reload Entities

- (void)reloadEntities
{
    [QUOrderManager synchronizeAllMyOrdersWithSuccessHandler:^(NSSet *orders) {
        [self.refreshControl endRefreshing];
    } failureHandler:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QUOrder *order = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    return [order lastModifiedAsString];
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
    QUOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUOrderTableViewCellID" forIndexPath:indexPath];
    
    cell.order = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    return cell;
}

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
                                                                              QUOrder *order = [self.fetchedResultsController objectAtIndexPath:indexPath];
                                                                              
                                                                              MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
                                                                              progressHUD.labelFont = [UIFont fontWithName:@"Montserrat-Regular" size:30.0f];
                                                                              progressHUD.detailsLabelFont = [UIFont fontWithName:@"Montserrat-Light" size:20.0f];
                                                                              
                                                                              // progressHUD.labelColor = [UIColor darkerDarkGrayColor];
                                                                              // progressHUD.detailsLabelColor = [UIColor darkerDarkGrayColor];
                                                                              
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

@end
