//
//  PFFetchedResultsControllerCViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.11.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFFetchedResultsControllerCViewController.h"

@implementation PFFetchedResultsControllerCViewController

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

	[self.collectionView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController != _fetchedResultsController) {
		_fetchedResultsController = fetchedResultsController;
		fetchedResultsController.delegate = self;

		if (fetchedResultsController) {
			[self performFetch];
		} else {
			[self.collectionView reloadData];
		}
	}
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return self.fetchedResultsController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSInteger numberOfItemsInSection = ((id <NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections[section]).numberOfObjects;
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - <NSFetchedResultsControllerDelegate>
/*
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
	switch (type) {
	case NSFetchedResultsChangeInsert:
		[self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
		break;

	case NSFetchedResultsChangeUpdate:
		[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
		break;

	case NSFetchedResultsChangeDelete:
		[self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
		break;

	case NSFetchedResultsChangeMove:
		[self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
		[self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
		break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	switch (type) {
	case NSFetchedResultsChangeInsert:
		[self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
		break;

	case NSFetchedResultsChangeDelete:
		[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
		break;

	case NSFetchedResultsChangeUpdate:
		[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
		break;

	case NSFetchedResultsChangeMove:
		[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
		[self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
		break;
	}
}*/

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

@end
