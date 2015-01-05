//
//  QCAuthViewController.m
//  qivicon Demo
//
//  Created by Alexander v. Below on 01.03.13.
//  Copyright (c) 2013 Alexander v. Below. All rights reserved.
//

#import "QDAuthViewController.h"
#import <qivicon/qivicon.h>

@interface QDAuthViewController ()
@property (nonatomic) QCAuthorizedConnection *connection;
@end

@implementation QDAuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(NO, @"Do not call");
    return nil;
}

- (id)initWithConnection:(QCAuthorizedConnection *)connection
                delegate:(id <QCOAuthViewDelegate>)delegate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.delegate = delegate;
        self.connection = connection;
    }
    return self;
}

- (void) loadView {
    
    self.view = [[QCOAuth2View alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                         connection:self.connection
                                           delegate:self.delegate];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
