//
//  CWStatusBarNotification+Quanto.h
//  Quanto
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import "CWStatusBarNotification.h"

@interface CWStatusBarNotification (Quanto)

+ (void)displaySuccessNotificationWithText:(NSString *)text;
+ (void)displayErrorNotificationWithText:(NSString *)text;

@end
