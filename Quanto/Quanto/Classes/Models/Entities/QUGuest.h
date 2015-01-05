//
//  QUGuest.h
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QUKey, QUStay;

@interface QUGuest : NSManagedObject

@property (nonatomic, retain) NSData * avatarData;
@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * guestID;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * salutation;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *keys;
@property (nonatomic, retain) NSSet *stays;
@end

@interface QUGuest (CoreDataGeneratedAccessors)

- (void)addKeysObject:(QUKey *)value;
- (void)removeKeysObject:(QUKey *)value;
- (void)addKeys:(NSSet *)values;
- (void)removeKeys:(NSSet *)values;

- (void)addStaysObject:(QUStay *)value;
- (void)removeStaysObject:(QUStay *)value;
- (void)addStays:(NSSet *)values;
- (void)removeStays:(NSSet *)values;

@end
