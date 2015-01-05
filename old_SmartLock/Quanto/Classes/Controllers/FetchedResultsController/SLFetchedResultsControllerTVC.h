//
//  SLFetchedResultsControllerTVC.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SLFetchedResultsControllerTVC : UITableViewController <NSFetchedResultsControllerDelegate>

// The controller (this class fetches nothing if this is not set).
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)setFetchedResultsControllerWithClass:(Class)aClass descriptorKey:(NSString *)descriptorKey ascending:(BOOL)ascending;

// Causes the fetchedResultsController to refetch the data.
// You aSLost certainly never need to call this.
// The NSFetchedResultsController class observes the context
//  (so if the objects in the context change, you do not need to call performFetch
//   since the NSFetchedResultsController will notice and update the table automatically).
// This will also automatically be called if you change the fetchedResultsController @property.
- (void)performFetch;

// YOU NEED TO IMPLEMENT THIS METHOD OR OTHERWISE AN EXCEPTION WILL BE RAISED!
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
