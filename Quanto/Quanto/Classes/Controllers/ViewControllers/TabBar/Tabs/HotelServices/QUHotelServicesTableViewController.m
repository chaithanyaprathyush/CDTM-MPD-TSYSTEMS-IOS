//
//  QUHotelServicesTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUHotelServicesTableViewController.h"
#import "QUServiceTypeManager.h"
#import "QUHotelServiceTableViewCell.h"
#import "MZFormSheetController.h"
#import "QUHotelServiceDetailsViewController.h"

@implementation QUHotelServicesTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super createFetchedResultsControllerWithClass:[QUService class]
                                     descriptorKeys:@[@"serviceType.serviceTypeID", @"price"]
                                         ascending:@[@YES, @NO]
                                sectionNameKeyPath:@"serviceType.serviceTypeID"];
    
    [super enablePullToRefresh];
    
    super.reloadEntitiesInterval = 60.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Reload Entities

- (void)reloadEntities
{
    [QUServiceTypeManager synchronizeAllServiceTypesWithSuccessHandler:^(NSSet *serviceTypes) {
        [self.refreshControl endRefreshing];
    } failureHandler:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QUService *service = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    return service.serviceType.name;
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
    QUHotelServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUHotelServiceTableViewCellID" forIndexPath:indexPath];
    
    cell.service = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
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
        hotelServiceDetailsViewController.service = [self.fetchedResultsController objectAtIndexPath:indexPath];
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}

@end
