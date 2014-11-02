//
//  SLUser.h
//  SmartLock
//
//  Created by Pascal Fritzen on 01.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLAccessLogEntry, SLUserProfile;

@interface SLUser : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSDate * joinedAt;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *accessLogEntries;
@property (nonatomic, retain) SLUserProfile *userProfile;
@end

@interface SLUser (CoreDataGeneratedAccessors)

- (void)addAccessLogEntriesObject:(SLAccessLogEntry *)value;
- (void)removeAccessLogEntriesObject:(SLAccessLogEntry *)value;
- (void)addAccessLogEntries:(NSSet *)values;
- (void)removeAccessLogEntries:(NSSet *)values;

@end
