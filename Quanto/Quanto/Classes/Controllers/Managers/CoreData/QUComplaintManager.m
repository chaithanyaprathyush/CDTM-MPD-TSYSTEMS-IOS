//
//  QUComplaintManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 09.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUComplaintManager.h"
#import "QUGuestManager.h"

// REST API Endpoints
static NSString *QUAPIEndpointComplaints    = @"complaints/";
static NSString *QUAPIEndpointMyComplaints  = @"complaints/my/";
static NSString *QUAPIEndpointComplaint     = @"complaints/:complaintID/";

@implementation QUComplaintManager

#pragma mark - CoreData

+ (Class)entityClass
{
	return [QUComplaint class];
}

+ (NSString *)entityIDKey
{
	return @"complaintID";
}

+ (BOOL)shouldInvokeSimpleUpdate
{
	return NO;
}

+ (BOOL)checkToUpdateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	QUComplaint *complaint = entity;
	BOOL didUpdate = NO;

	if (![complaint.status isEqualToString:JSON[@"status"]]) {
		complaint.status = JSON[@"status"];
		didUpdate = YES;
	}
    
    if (![complaint.pictureURL isEqualToString:JSON[@"picture"]]) {
        complaint.pictureURL = JSON[@"picture"];
        didUpdate = YES;
    }
    
    if (![complaint.descriptionText isEqualToString:JSON[@"description"]]) {
        complaint.descriptionText = JSON[@"description"];
        didUpdate = YES;
    }

	if (![complaint.createdAt isEqualToDate:[JSON dateForKey:@"date_created"]]) {
		complaint.createdAt = [JSON dateForKey:@"date_created"];
		didUpdate = YES;
	}

	if (![complaint.lastModifiedAt isEqualToDate:[JSON dateForKey:@"last_modified"]]) {
		complaint.lastModifiedAt = [JSON dateForKey:@"last_modified"];
		didUpdate = YES;
	}

	QUGuest *guest = [QUGuestManager fetchOrCreateEntityWithEntityID:JSON[@"guest"]];
	if (complaint.guest != guest) {
		complaint.guest = guest;
		didUpdate = YES;
	}

	if (didUpdate) {
		//DLOG(@"Updated Complaint with JSON:%@\n%@", JSON, complaint);
		DLOG(@"Did Update QUComplaint %@", complaint.complaintID);
	}

	return didUpdate;
}

#pragma mark - REST-API

+ (void)createComplaintWithPicture:(UIImage *)picture descriptionText:(NSString *)descriptionText successHandler:(void (^)(QUComplaint *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSDictionary *parameters = @{@"description":descriptionText};

	DLOG(@"Create Complaint with parameters: %@", parameters);

	[[PFRESTManager sharedManager].operationManager POST:QUAPIEndpointComplaints
                                              parameters:parameters
                               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		 [formData appendPartWithFileData:UIImageJPEGRepresentation(picture, 1.0f) name:@"picture" fileName:@"picture.jpg" mimeType:@"image/jpeg"];
	 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 QUComplaint *complaint = [self updateOrCreateEntityWithJSON:responseObject];

		 DLOG(@"Success!");
		 successHandler(complaint);
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

+ (void)synchronizeComplaintWithComplaintID:(NSNumber *)complaintID successHandler:(void (^)(QUComplaint *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	NSString *endpoint = [QUAPIEndpointComplaint stringByReplacingOccurrencesOfString:@":complaintID" withString:[complaintID stringValue]];
	[super fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllMyComplaintsWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[super fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyComplaints successHandler:successHandler failureHandler:failureHandler];
}

+ (void)deleteComplaintWithComplaintID:(NSNumber *)complaintID successHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Delete Complaint %@", [complaintID stringValue]);

	NSString *endpoint = [QUAPIEndpointComplaint stringByReplacingOccurrencesOfString:@":complaintID" withString:[complaintID stringValue]];

	[[PFRESTManager sharedManager].operationManager DELETE:endpoint
												parameters:nil
												   success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 [[PFCoreDataManager sharedManager].managedObjectContext deleteObject:[self fetchOrCreateEntityWithEntityID:complaintID]];
		 [[PFCoreDataManager sharedManager] save];

		 DLOG(@"Success!");
		 successHandler();
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

@end
