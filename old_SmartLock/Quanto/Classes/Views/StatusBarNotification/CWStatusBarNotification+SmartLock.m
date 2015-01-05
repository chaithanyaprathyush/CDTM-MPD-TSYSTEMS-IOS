//
//  CWStatusBarNotification+Quanto.m
//  Quanto
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "CWStatusBarNotification+Quanto.h"
#import <UIKit/UIKit.h>

@implementation CWStatusBarNotification (Dono)

+ (CWStatusBarNotification *)defaultNotification
{
	CWStatusBarNotification *notification = [CWStatusBarNotification new];
	
    notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
	
    notification.notificationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
	
    notification.notificationAnimationType = CWNotificationAnimationStyleTop;
    
	return notification;
}

+ (void)displaySuccessNotificationWithText:(NSString *)text
{
	CWStatusBarNotification *notification = [self defaultNotification];
    
	notification.notificationLabelBackgroundColor = [UIColor colorWithRed:115.0/255.0 green:155.0/255.0 blue:47.0/255.0 alpha:1];
	
    [notification displayNotificationWithMessage:text forDuration:2.5f];
}

+ (void)displayErrorNotificationWithText:(NSString *)text
{
	CWStatusBarNotification *notification = [self defaultNotification];
    
	notification.notificationLabelBackgroundColor = [UIColor colorWithRed:239.0/255.0 green:130.0/255.0 blue:41.0/255.0 alpha:1];
	
    [notification displayNotificationWithMessage:text forDuration:2.5f];
}

@end
