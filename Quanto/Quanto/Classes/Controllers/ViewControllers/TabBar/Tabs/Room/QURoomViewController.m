//
//  QURoomViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QURoomViewController.h"
#import <CoreData/CoreData.h>
#import "QULock.h"
#import "QURoom.h"
#import "PFCoreDataManager.h"
#import "QUGuestManager.h"
#import "QUKeyManager.h"
#import "QULoginViewController.h"
#import "QURoom+QUUtils.h"

@interface QURoomViewController ()

@property (nonatomic, retain) NSFetchRequest *locksFetchRequest;
@property (nonatomic, retain) NSArray *fetchedLocks;

@property (nonatomic, retain) NSTimer *reloadLocksTimer;

@end

@implementation QURoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.locksFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QULock class])];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.number" ascending:YES];
    self.locksFetchRequest.sortDescriptors = @[descriptor];
    
    [self fetchLocks];
    
    [self performSelector:@selector(reloadLocks) withObject:nil afterDelay:0.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.reloadLocksTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reloadLocks) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.reloadLocksTimer invalidate];
    self.reloadLocksTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Reload Locks

- (void)reloadLocks
{
    if ([QUGuestManager isCurrentGuestLoggedIn]) {
        [QUKeyManager synchronizeAllMyKeysWithSuccessHandler:^(NSSet *keys) {
            //[self.refreshControl endRefreshing];
            [self fetchLocks];
        } failureHandler:^(NSError *error) {
            //[self.refreshControl endRefreshing];
            [self fetchLocks];
        }];
    } else {
        [QULoginViewController showWithPresentingViewController:self successHandler:^(QUGuest *guest) {
            [self reloadLocks];
        } failureHandler:^(NSError *error) {
            [self reloadLocks];
        }];
    }
}

- (void)fetchLocks
{
    NSError *error = nil;
    
    self.fetchedLocks = [[PFCoreDataManager sharedManager].managedObjectContext executeFetchRequest:self.locksFetchRequest error:&error];

    if (self.fetchedLocks == nil) {
        // Error Handling
        self.noRoomMessageLabel.hidden = NO;
    } else {
        self.noRoomMessageLabel.hidden = YES;
        
        QULock *lock = [self.fetchedLocks firstObject];
        
        self.roomNumberLabel.text = [NSString stringWithFormat:@"Room No. %i", [lock.room.number intValue]];
        self.roomDetailsLabel.text = lock.room.descriptionText;
        
        [lock.room downloadPictureWithSuccessHandler:^{
            self.roomPictureImageView.image = [UIImage imageWithData:lock.room.pictureData];
        } failureHandler:^(NSError *error) {
            DLOG(@"FAIL");
        }];
    }
}

#pragma mark - IBActions

- (IBAction)didTouchOpenDoorButton:(id)sender
{
    NSLog(@"hi");
}

@end
