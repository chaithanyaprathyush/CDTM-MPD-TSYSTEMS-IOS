//
//  QUComplaint.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QUGuest;

@interface QUComplaint : NSManagedObject

@property (nonatomic, retain) NSNumber * complaintID;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSData * pictureData;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * lastModifiedAt;
@property (nonatomic, retain) QUGuest *guest;

@end
