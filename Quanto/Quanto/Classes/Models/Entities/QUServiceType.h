//
//  QUServiceType.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QUService;

@interface QUServiceType : NSManagedObject

@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * pictureData;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSNumber * serviceTypeID;
@property (nonatomic, retain) NSSet *services;
@end

@interface QUServiceType (CoreDataGeneratedAccessors)

- (void)addServicesObject:(QUService *)value;
- (void)removeServicesObject:(QUService *)value;
- (void)addServices:(NSSet *)values;
- (void)removeServices:(NSSet *)values;

@end
