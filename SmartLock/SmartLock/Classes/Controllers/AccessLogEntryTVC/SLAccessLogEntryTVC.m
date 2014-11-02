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

@interface SLAccessLogEntryTVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSArray *accessLogEntries;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SLAccessLogEntryTVC

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SLAccessLogEntry"];
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
	fetchRequest.sortDescriptors = @[descriptor];

	// Setup fetched results
	NSError *error = nil;
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	self.fetchedResultsController.delegate = self;

	BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
	if (!fetchSuccessful) {
		NSLog(@"Error: %@", error);
	} else {
		NSLog(@"SUCCESS: %@", [self.fetchedResultsController fetchedObjects]);
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self reloadAccessLogEntries];
}

- (void)reloadAccessLogEntries
{
	if ([[SLUserManager sharedManager] isCurrentUserLoggedIn]) {
		[[SLAccessLogEntryManager sharedManager] fetchAllAccessLogEntriesWithCompletionHandler:^(NSError *error, NSArray *accessLogEntries) {
			 if (error) {
				 NSLog(@"Error: %@", error);
			 } else {
				 self.accessLogEntries = accessLogEntries;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.accessLogEntries count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"accessLogEntryCellID";
	SLAccessLogEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	//    cell.textLabel.text = [accessLogEntry.userIdentifier stringValue];
//    cell.detailTextLabel.text = accessLogEntry.action;

	return cell;
}

- (void)styleCell:(SLAccessLogEntryTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLAccessLogEntry *accessLogEntry = self.accessLogEntries[indexPath.row];
    
    if (accessLogEntry.user) {
        NSLog(@"Found user: %@", accessLogEntry.user);
        
        if (accessLogEntry.user.userProfile) {
            NSLog(@"Found user Profile: %@", accessLogEntry.user.userProfile);
            
            if (accessLogEntry.user.userProfile.avatarURL) {
                NSLog(@"User has an avatar!");
                
                if (accessLogEntry.user.userProfile.avatarImageData) {
                    NSLog(@" found image data for user profile!");
                    cell.avatarImageView.image = [UIImage imageWithData:accessLogEntry.user.userProfile.avatarImageData];
                } else {
                    [self downloadAvatarForUserProfile:accessLogEntry.user.userProfile WithCompletionHandler:^(NSData *imageData) {
                        cell.avatarImageView.image = [UIImage imageWithData:accessLogEntry.user.userProfile.avatarImageData];
                    }];
                }
            } else {
                NSLog(@"User has no avatar!");
            }
        } else {
            NSLog(@"No user profile found!");
            
            [[SLUserProfileManager sharedManager] fetchUserProfileForUser:accessLogEntry.user completionHandler:^(NSError *error, SLUserProfile *userProfile) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    [self styleCell:cell forRowAtIndexPath:indexPath];
                }
            }];
        }
    } else {
        NSLog(@"No user found?!?");
    }

    cell.nameLabel.text = [NSString stringWithFormat:@"%@, %@", accessLogEntry.user.lastName, accessLogEntry.user.firstName];
    cell.actionLabel.text = accessLogEntry.action;
}

- (void)downloadAvatarForUserProfile:(SLUserProfile *)userProfile WithCompletionHandler:(void (^) (NSData *imageData))completionHandler
{
	dispatch_async(dispatch_queue_create("Download Avatar", nil), ^{
					   NSURL *avatarURL = [NSURL URLWithString:[[BASE_URL_STRING stringByReplacingOccurrencesOfString:@"/api/" withString:@"/media/"] stringByAppendingString:userProfile.avatarURL]];
					   NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
					   dispatch_async(dispatch_get_main_queue(), ^{
	                                      // cell.avatarImageView.image = [UIImage imageWithData:avatarData];
										  completionHandler(avatarData);
									  });
				   });
}

#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@"UPDATE: %@", [self.fetchedResultsController fetchedObjects]);

	[self.tableView reloadData];
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
