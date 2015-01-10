//
//  PFFetchedResultsControllerTViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFFetchedResultsControllerTViewController.h"
#import "PFCoreDataManager.h"

@interface PFFetchedResultsControllerTViewController ()

@property (nonatomic, retain) NSTimer *reloadEntitiesTimer;

@end

@implementation PFFetchedResultsControllerTViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.reloadEntitiesInterval > 0.0f) {
        [self scheduleReloadEntitiesWithTimeInterval:self.reloadEntitiesInterval reloadNow:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resetReloadEntitiesTimer];
}

#pragma mark - Utils


- (void)createFetchedResultsControllerWithClass:(Class)clazz descriptorKey:(NSString *)descriptorKey ascending:(BOOL)ascending sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    [self createFetchedResultsControllerWithClass:clazz descriptorKeys:@[descriptorKey] ascending:@[[NSNumber numberWithBool:ascending]] sectionNameKeyPath:sectionNameKeyPath];
}

- (void)createFetchedResultsControllerWithClass:(Class)clazz descriptorKeys:(NSArray *)descriptorKeys ascending:(NSArray *)ascending sectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(clazz)];
    
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:descriptorKeys.count];
    for (int i = 0; i < descriptorKeys.count; i++) {
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:descriptorKeys[i] ascending:[ascending[i] boolValue]]];
    }
    fetchRequest.sortDescriptors = sortDescriptors;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[PFCoreDataManager sharedManager].managedObjectContext
                                                                          sectionNameKeyPath:sectionNameKeyPath
                                                                                   cacheName:nil];
}


#pragma mark - Pull to Refresh

- (void)enablePullToRefresh
{
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor darkerDarkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadEntities)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)disablePullToRefresh
{
    self.refreshControl = nil;
}

#pragma mark - Reloading Entities

- (void)setReloadEntitiesInterval:(float)reloadEntitiesInterval
{
    _reloadEntitiesInterval = reloadEntitiesInterval;
    
    [self scheduleReloadEntitiesWithTimeInterval:reloadEntitiesInterval reloadNow:YES];
}

- (void)scheduleReloadEntitiesWithTimeInterval:(float)timeInterval reloadNow:(BOOL)reloadNow
{
    [self resetReloadEntitiesTimer];
    
    self.reloadEntitiesTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                                target:self
                                                              selector:@selector(reloadEntities)
                                                              userInfo:nil
                                                               repeats:YES];
    
    if (reloadNow) {
        // need to do this 0.0 because this method will be called in viewWillAppear and an
        // error will be thrown otherwise
        [self performSelector:@selector(reloadEntities) withObject:nil afterDelay:0.0f];
    }
}

- (void)resetReloadEntitiesTimer
{
    if (self.reloadEntitiesTimer) {
        [self.reloadEntitiesTimer invalidate];
        self.reloadEntitiesTimer = nil;
    }
}

- (void)reloadEntities
{
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Fetching

- (void)performFetch
{
	if (self.fetchedResultsController) {
		if (self.fetchedResultsController.fetchRequest.predicate) {
			NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
		} else {
			NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
		}

		NSError *error;
		BOOL success = [self.fetchedResultsController performFetch:&error];

		if (!success) {
			NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		}

		if (error) {
			NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
		}
	} else {
		NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	}

	[self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController != _fetchedResultsController) {
		_fetchedResultsController = fetchedResultsController;
		fetchedResultsController.delegate = self;

		if (fetchedResultsController) {
			[self performFetch];
		} else {
			[self.tableView reloadData];
		}
	}
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ((id <NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections[section]).numberOfObjects;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return ((id <NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections[section]).name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - <NSFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
	switch (type) {
	case NSFetchedResultsChangeInsert:
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]      withRowAnimation:UITableViewRowAnimationFade];
		break;

	case NSFetchedResultsChangeUpdate:
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]      withRowAnimation:UITableViewRowAnimationFade];
		break;

	case NSFetchedResultsChangeDelete:
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]      withRowAnimation:UITableViewRowAnimationFade];
		break;
	case NSFetchedResultsChangeMove:
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]      withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]      withRowAnimation:UITableViewRowAnimationFade];
		break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	switch (type) {
	case NSFetchedResultsChangeInsert:
		[self.tableView insertRowsAtIndexPaths:@[newIndexPath]  withRowAnimation:UITableViewRowAnimationFade];
		break;

	case NSFetchedResultsChangeDelete:
		[self.tableView deleteRowsAtIndexPaths:@[indexPath]     withRowAnimation:UITableViewRowAnimationFade];
		break;

	case NSFetchedResultsChangeUpdate:
		[self.tableView reloadRowsAtIndexPaths:@[indexPath]     withRowAnimation:UITableViewRowAnimationNone];
		break;

	case NSFetchedResultsChangeMove:
		[self.tableView deleteRowsAtIndexPaths:@[indexPath]     withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView insertRowsAtIndexPaths:@[newIndexPath]  withRowAnimation:UITableViewRowAnimationFade];
		break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView endUpdates];
}

@end
