//
//  PFFetchedResultsControllerTViewController.h
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PFFetchedResultsControllerTViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) float reloadEntitiesInterval;

// YOU NEED TO IMPLEMENT THIS METHOD OR OTHERWISE AN EXCEPTION WILL BE RAISED!
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// YOU NEED TO IMPLEMENT THIS METHOD OR OTHERWISE AN EXCEPTION WILL BE RAISED!
- (void)reloadEntities;

// Causes the fetchedResultsController to refetch the data.
// You almost certainly never need to call this.
// The NSFetchedResultsController class observes the context
//  (so if the objects in the context change, you do not need to call performFetch
//   since the NSFetchedResultsController will notice and update the table automatically).
// This will also automatically be called if you change the fetchedResultsController @property.
- (void)performFetch;

- (void)createFetchedResultsControllerWithClass:(Class)clazz descriptorKey:(NSString *)descriptorKey ascending:(BOOL)ascending sectionNameKeyPath:(NSString *)sectionNameKeyPath;
- (void)createFetchedResultsControllerWithClass:(Class)clazz descriptorKeys:(NSArray *)descriptorKeys ascending:(NSArray *)ascending sectionNameKeyPath:(NSString *)sectionNameKeyPath;

- (void)enablePullToRefresh;
- (void)disablePullToRefresh;

- (void)scheduleReloadEntitiesWithTimeInterval:(float)timeInterval reloadNow:(BOOL)reloadNow;
- (void)resetReloadEntitiesTimer;

@end
