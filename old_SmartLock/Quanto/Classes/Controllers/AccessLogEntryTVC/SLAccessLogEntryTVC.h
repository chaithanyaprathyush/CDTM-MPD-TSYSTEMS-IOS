//
//  SLAccessLogEntryTVC.h
//  Quanto
//
//  Created by Pascal Fritzen on 30.10.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFetchedResultsControllerTVC.h"

@interface SLAccessLogEntryTVC : SLFetchedResultsControllerTVC

- (IBAction)didTouchMenuButton:(id)sender;

- (IBAction)didTouchRefreshButton:(id)sender;

@end
