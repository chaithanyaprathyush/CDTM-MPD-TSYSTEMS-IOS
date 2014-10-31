//
//  DrawerMenuVC.h
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerViewController.h>

@class DrawerMenuVC;

@interface DrawerRootVC : MSDynamicsDrawerViewController

+ (DrawerRootVC *)sharedInstance;

@property (nonatomic, retain) DrawerMenuVC *menuController;

- (void)selectMenuIndex:(int)index;

- (void)showMenu;

@end
