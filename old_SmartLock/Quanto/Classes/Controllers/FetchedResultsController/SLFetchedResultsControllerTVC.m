//
//  SLFetchedResultsControllerTVC.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "SLFetchedResultsControllerTVC.h"
#import "SLCoreDataManager.h"

@implementation SLFetchedResultsControllerTVC

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

- (void)setFetchedResultsControllerWithClass:(Class)aClass descriptorKey:(NSString *)descriptorKey ascending:(BOOL)ascending
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(aClass)];
	fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:descriptorKey ascending:ascending]];

	// Setup fetched results
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:[SLCoreDataManager sharedManager].managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
}

#pragma mark - UITableViewDataSource

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

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return self.fetchedResultsController.sectionIndexTitles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - NSFetchedResultsControllerDelegate

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
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	switch (type) {
	case NSFetchedResultsChangeInsert:
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]   withRowAnimation:UITableViewRowAnimationFade];
		break;

	case NSFetchedResultsChangeDelete:
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]      withRowAnimation:UITableViewRowAnimationFade];
		break;

	case NSFetchedResultsChangeUpdate:
		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]      withRowAnimation:UITableViewRowAnimationFade];
		break;

	case NSFetchedResultsChangeMove:
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]      withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]   withRowAnimation:UITableViewRowAnimationFade];
		break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView endUpdates];
}

@end
