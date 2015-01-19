//
//  QUComplaintManager.h
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "PFEntityManager.h"
#import "QUComplaint.h"

@interface QUComplaintManager : PFEntityManager

+ (QUComplaintManager *)sharedManager;

+ (void)createComplaintWithPicture:(UIImage *)picture descriptionText:(NSString *)descriptionText successHandler:(void (^)(QUComplaint *complaint))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)synchronizeComplaintWithComplaintID:(NSNumber *)complaintID successHandler:(void (^)(QUComplaint *complaint))successHandler failureHandler:(void (^)(NSError *error))failureHandler;
+ (void)synchronizeAllMyComplaintsWithSuccessHandler:(void (^)(NSSet *complaints))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

+ (void)deleteComplaintWithComplaintID:(NSNumber *)complaintID successHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *error))failureHandler;

@end
