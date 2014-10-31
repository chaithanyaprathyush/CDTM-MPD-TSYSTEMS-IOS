//
//  DrawerMenuVC.h
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerRootVC.h"
#import "BaseVC.h"

@interface DrawerMenuVC : BaseVC

@property (nonatomic, weak) DrawerRootVC *drawerRootVC;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) int selectedControllerIndex;

- (void)setSelectedControllerIndex:(int)index animated:(BOOL)animated;

@end
