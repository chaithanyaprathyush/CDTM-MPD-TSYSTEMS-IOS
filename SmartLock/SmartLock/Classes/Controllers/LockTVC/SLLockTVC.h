//
//  SLLockTVC.h
//  SmartLock
//
//  Created by Pascal Fritzen on 27.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFetchedResultsControllerTVC.h"

@interface SLLockTVC : SLFetchedResultsControllerTVC

- (IBAction)didTouchMenuButton:(id)sender;

- (IBAction)didTouchRefreshButton:(id)sender;

@end
