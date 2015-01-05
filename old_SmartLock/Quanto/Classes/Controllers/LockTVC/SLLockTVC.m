//
//  SLLockTVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLLockTVC.h"
#import "SLUserManager.h"
#import "SLLockManager.h"
#import "SLLockVC.h"
#import "SLLoginVC.h"
#import "SLDrawerRootVC.h"

@interface SLLockTVC ()

@end

@implementation SLLockTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [super setFetchedResultsControllerWithClass:[SLLock class]
                                  descriptorKey:@"name"
                                      ascending:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLLockTableViewCellID"];
    
    SLLock *lock = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = lock.name;
    cell.detailTextLabel.text = [lock.lockID stringValue];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"showLock"]) {
        SLLockVC *lockVC = segue.destinationViewController;
        lockVC.lock = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

#pragma mark - Utils

- (void)reloadLocks
{
    if ([SLUserManager isCurrentUserLoggedIn]) {
        [SLLockManager synchronizeAllLocksWithCompletionHandler:^(NSError *error, NSArray *locks) {
            [self.tableView reloadData];
        }];
    } else {
        [SLLoginVC showWithViewController:self completionHandler:^{
            [self reloadLocks];
        }];
    }
}

#pragma mark - IBActions

- (IBAction)didTouchRefreshButton:(id)sender
{
    [self reloadLocks];
}

- (IBAction)didTouchMenuButton:(id)sender
{
    [[SLDrawerRootVC sharedInstance] showMenu];
}

@end
