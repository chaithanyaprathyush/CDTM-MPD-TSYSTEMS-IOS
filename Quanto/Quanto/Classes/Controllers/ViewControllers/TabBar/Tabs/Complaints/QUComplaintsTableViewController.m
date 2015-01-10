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

@interface QUComplaintsTableViewController ()

@property (nonatomic, retain) NSTimer *reloadEntitiesTimer;

@end

@implementation QUComplaintsTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QUComplaint class])];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastModifiedAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[PFCoreDataManager sharedManager].managedObjectContext
                                                                          sectionNameKeyPath:@"lastModifiedAtDateOnly"
                                                                                   cacheName:nil];
    // Pull to refresh
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor darkerDarkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadEntities)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(reloadEntities) withObject:nil afterDelay:0.0f];
    
    [self scheduleReloadEntitiesWithTimeInterval:10.0f];
    [self performSelector:@selector(reloadEntities) withObject:nil afterDelay:0.0f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resetReloadEntitiesTimer];
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

/*
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
}*/

#pragma mark - IBActions

@end
