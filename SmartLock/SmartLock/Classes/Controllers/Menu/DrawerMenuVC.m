//
//  DrawerMenuVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "DrawerMenuVC.h"
#import "MenuTableViewCell.h"

@interface DrawerMenuVC () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation DrawerMenuVC

/*****************************************************/
#pragma mark - View Lifecycle
/*****************************************************/

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		_selectedControllerIndex = -1;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

/*****************************************************/
#pragma mark - Helpers
/*****************************************************/

- (void)setSelectedControllerIndex:(int)selectedControllerIndex
{
	[self setSelectedControllerIndex:selectedControllerIndex animated:NO];
}

- (void)setSelectedControllerIndex:(int)selectedControllerIndex animated:(BOOL)animated
{
	if (selectedControllerIndex != _selectedControllerIndex && selectedControllerIndex < self.menuItems.count) {
		_selectedControllerIndex = selectedControllerIndex;

		NSDictionary *selectedItem = self.menuItems[_selectedControllerIndex];
		UIViewController *selectedController = (UIViewController *)[[selectedItem allValues] firstObject];

		[self.drawerRootVC setPaneViewController:selectedController animated:animated completion:nil];
	}

	[self.drawerRootVC setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:^{
	     // Pane has come to rest
	 }];
}

/*****************************************************/
#pragma mark - UITableViewDataSource
/*****************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (long) self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell" forIndexPath:indexPath];

	NSString *itemName = [[self.menuItems[indexPath.row] allKeys] firstObject];
	cell.itemLabel.text = itemName;

	return cell;
}

/*****************************************************/
#pragma mark - UITableViewDelegate
/*****************************************************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedControllerIndex = (int) indexPath.row;
}

@end
