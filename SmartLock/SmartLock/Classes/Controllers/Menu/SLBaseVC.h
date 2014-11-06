//
//  SLBaseVC.h
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLBaseVC : UIViewController

+ (UIViewController *)instantiateViewControllerInNavigationControllerWithIdentifier:(NSString *)identifier;
+ (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier;

@end
