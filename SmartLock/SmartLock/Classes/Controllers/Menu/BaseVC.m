//
//  BaseVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIViewController *)instantiateViewControllerInNavigationControllerWithIdentifier:(NSString *)identifier
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[self instantiateViewControllerWithIdentifier:identifier]];
    return controller;
}

/*
+ (UIViewController *)instantiateItemCVCInNavigationControllerWithItemStatus:(ItemStatus)itemStatus
{
    ItemCVC *itemCVC = (ItemCVC *)[self instantiateViewControllerWithIdentifier:@"ItemCVC"];
    itemCVC.itemStatus = itemStatus;
    
    return [[UINavigationController alloc] initWithRootViewController:itemCVC];
}*/

+ (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
}

@end
