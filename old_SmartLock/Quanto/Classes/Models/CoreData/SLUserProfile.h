//
//  SLUserProfile.h
//  Quanto
//
//  Created by Pascal Fritzen on 02.11.14.
//  Copyright (c) 2014 Center for Digital Management. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLUser;

@interface SLUserProfile : NSManagedObject

@property (nonatomic, retain) NSData * avatarImageData;
@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSNumber * userProfileID;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) SLUser *user;

@end
