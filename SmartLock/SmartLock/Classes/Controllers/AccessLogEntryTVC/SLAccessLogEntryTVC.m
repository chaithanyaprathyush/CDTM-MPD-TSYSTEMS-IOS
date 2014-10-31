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

@interface SLAccessLogEntryTVC ()

@property (nonatomic, retain) NSArray *accessLogEntries;

@end

@implementation SLAccessLogEntryTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
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

	SLAccessLogEntry *accessLogEntry = self.accessLogEntries[indexPath.row];

	[[SLUserProfileManager sharedManager] fetchUserProfileForUserIdentifier:accessLogEntry.userIdentifier completionHandler:^(NSError *error, SLUserProfile *userProfile) {
		 if (error) {
			 NSLog(@"Error: %@", error);
		 } else {
			 dispatch_async(dispatch_queue_create("Download Avatar", nil), ^{
								NSURL *avatarURL = [NSURL URLWithString:[[BASE_URL_STRING stringByReplacingOccurrencesOfString:@"/api/" withString:@"/media/"] stringByAppendingString:userProfile.avatar]];
								NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
								dispatch_async(dispatch_get_main_queue(), ^{
												   //cell.avatarImageView.image = [UIImage imageWithData:avatarData];
                                    cell.avatarImageView.image = [UIImage imageWithData:avatarData];
											   });
							});
		 }
	 }];

	cell.nameLabel.text = [accessLogEntry.userIdentifier stringValue];
	cell.actionLabel.text = accessLogEntry.action;
//    cell.textLabel.text = [accessLogEntry.userIdentifier stringValue];
//    cell.detailTextLabel.text = accessLogEntry.action;

	return cell;
}

/*
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
   {
    if ([segue.identifier isEqual:@"showLock"]) {
        SLLockVC *lockVC = segue.destinationViewController;
        lockVC.lock = self.locks[[self.tableView indexPathForSelectedRow].row];
    }
   }*/

- (IBAction)didTouchRefreshButton:(id)sender
{
	[self reloadAccessLogEntries];
}

- (IBAction)didTouchMenuButton:(id)sender
{
	[[DrawerRootVC sharedInstance] showMenu];
}

@end
