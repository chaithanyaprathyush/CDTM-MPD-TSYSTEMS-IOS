//
//  QCAuthViewController.h
//  qivicon Demo
//
//  Created by Alexander v. Below on 01.03.13.
//  Copyright (c) 2013 Alexander v. Below. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <qivicon/qivicon.h>

@interface QDAuthViewController : UIViewController
@property (weak) id <QCOAuthViewDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("Call initWithConnection:delegate: instead!")));

- (id)initWithConnection:(QCAuthorizedConnection *)connection
                delegate:(id <QCOAuthViewDelegate>)delegate;

@end
