//
//  SLAccessLogEntryTVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLAccessLogEntryTVC.h"
#import "SLLoginVC.h"
#import "SLUserManager.h"
#import "DrawerRootVC.h"
#import "SLAccessLogEntryManager.h"
#import "SLUserProfileManager.h"
#import "SLAccessLogEntryTableViewCell.h"
#import "SLRESTManager.h"
#import "SLUser.h"
#import "SLLockManager.h"

@interface SLAccessLogEntryTVC ()

@property (nonatomic, retain) NSMutableSet *userProfileIDsToFetch;
@property (nonatomic, retain) NSMutableSet *lockIDsToFetch;

@end

@implementation SLAccessLogEntryTVC

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.userProfileIDsToFetch = [NSMutableSet set];
	self.lockIDsToFetch = [NSMutableSet set];

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SLAccessLogEntry"];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
	fetchRequest.sortDescriptors = @[descriptor];

	// Setup fetched results
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	//[self reloadAccessLogEntries];
}

- (void)reloadAccessLogEntries
{
	if ([[SLUserManager sharedManager] isCurrentUserLoggedIn]) {
		[[SLAccessLogEntryManager sharedManager] fetchAllAccessLogEntriesWithCompletionHandler:^(NSError *error, NSArray *accessLogEntries) {
			 if (error) {
				 NSLog(@"Error: %@", error);
			 } else {
				 [self.tableView reloadData];
			 }
		 }];
	} else {
		[SLLoginVC showWithViewController:self completionHandler:^{
			 [self reloadAccessLogEntries];
		 }];
	}
}

#pragma mark - <UITableViewDataSource>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"accessLogEntryCellID";
	SLAccessLogEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	SLAccessLogEntry *accessLogEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.accessLogEntry = accessLogEntry;

	if (!accessLogEntry.user.userProfile && ![self.userProfileIDsToFetch containsObject:accessLogEntry.user.userProfileID]) {
		[self.userProfileIDsToFetch addObject:accessLogEntry.user.userProfileID];
		[[SLUserProfileManager sharedManager] fetchUserProfileWithUserProfileID:accessLogEntry.user.userProfileID completionHandler:^(NSError *error, SLUserProfile *userProfile) {
            [self downloadAvatarForUserProfile:userProfile withCompletionHandler:^(NSData *imageData) {
                [self.userProfileIDsToFetch removeObject:accessLogEntry.user.userProfileID];
                [self.tableView reloadData];
            }];
		 }];
	}
    
    if (!accessLogEntry.lock && ![self.lockIDsToFetch containsObject:accessLogEntry.lockID]) {
        [self.lockIDsToFetch addObject:accessLogEntry.lockID];
        [[SLLockManager sharedManager] fetchLockWithLockID:accessLogEntry.lockID completionHandler:^(NSError *error, SLLock *lock) {
            [self.lockIDsToFetch removeObject:accessLogEntry.lockID];
        }];
    }

	return cell;
}

- (void)downloadAvatarForUserProfile:(SLUserProfile *)userProfile withCompletionHandler:(void (^) (NSData *imageData))completionHandler
{
    dispatch_async(dispatch_queue_create("Download Avatar", nil), ^{
					   NSURL *avatarURL = [NSURL URLWithString:[[BASE_URL_STRING stringByReplacingOccurrencesOfString:@"/api/" withString:@"/media/"] stringByAppendingString:userProfile.avatarURL]];
					   NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
					   dispatch_async(dispatch_get_main_queue(), ^{
                           userProfile.avatarImageData = avatarData;
                           [[SLRESTManager sharedManager].objectManager.managedObjectStore.mainQueueManagedObjectContext refreshObject:userProfile mergeChanges:YES];
                           NSError *error;
                           [[SLRESTManager sharedManager].objectManager.managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:&error];
                           completionHandler(avatarData);
                       });
    });
}

#pragma mark - IBActions

- (IBAction)didTouchRefreshButton:(id)sender
{
	[self reloadAccessLogEntries];
}

- (IBAction)didTouchMenuButton:(id)sender
{
	[[DrawerRootVC sharedInstance] showMenu];
}

@end
