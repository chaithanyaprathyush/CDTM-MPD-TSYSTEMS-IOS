//
//  SLBaseVC.m
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "SLBaseVC.h"

@implementation SLBaseVC

+ (UIViewController *)instantiateViewControllerInNavigationControllerWithIdentifier:(NSString *)identifier
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[self instantiateViewControllerWithIdentifier:identifier]];
    return controller;
}

+ (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
}

@end
