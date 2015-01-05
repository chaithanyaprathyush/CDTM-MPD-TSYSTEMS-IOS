//
//  SLDrawerMenuVC.h
//  Quanto
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerViewController.h>

@class SLDrawerMenuVC;

@interface SLDrawerRootVC : MSDynamicsDrawerViewController

+ (SLDrawerRootVC *)sharedInstance;

@property (nonatomic, retain) SLDrawerMenuVC *menuController;

- (void)selectMenuIndex:(int)index;

- (void)showMenu;

@end
