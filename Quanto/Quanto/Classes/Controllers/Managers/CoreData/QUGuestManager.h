//
//  QUGuestManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 30.12.14.
//  Copyright (c) 2014 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUGuest.h"

@interface QUGuestManager : PFEntityManager

+ (QUGuestManager *)sharedManager;

+ (QUGuest *)currentGuest;
@property(strong, nonatomic) QUGuest *currentGuest;

#pragma mark - CoreData & REST-API

+ (BOOL)isCurrentGuestLoggedIn;
+ (void)logOutCurrentGuest;

+ (void)createGuestWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email firstName:(NSString *)firstName lastName:(NSString *)lastName successHandler:(void (^)(QUGuest *guest))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)synchronizeGuestWithSuccessHandler:(void (^)(QUGuest *guest))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)synchronizeGuestWithGuestID:(NSNumber *)guestID successHandler:(void (^)(QUGuest *guest))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
