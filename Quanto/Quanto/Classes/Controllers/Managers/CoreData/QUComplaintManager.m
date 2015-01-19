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

#pragma mark - Singleton

+ (QUComplaintManager *)sharedManager
{
	static QUComplaintManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUComplaintManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.entityClass = [QUComplaint class];

		self.entityLocalIDKey = @"complaintID";
	}
	return self;
}

- (BOOL)updateEntity:(id)entity withJSON:(NSDictionary *)JSON
{
	BOOL didUpdateAtLeastOneValue = NO;

	QUComplaint *complaint = entity;

	if ([JSON hasNonNullStringForKey:@"status"]) {
		complaint.status = JSON[@"status"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"picture"]) {
		complaint.pictureURL = JSON[@"picture"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullStringForKey:@"description"]) {
		complaint.descriptionText = JSON[@"description"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullDateForKey:@"date_created"]) {
		complaint.createdAt = [JSON dateForKey:@"date_created"];
		didUpdateAtLeastOneValue = YES;
	}

	if ([JSON hasNonNullDateForKey:@"last_modified"]) {
		complaint.lastModifiedAt = [JSON dateForKey:@"last_modified"];
		didUpdateAtLeastOneValue = YES;
	}

	if (JSON[@"guest"]) {
		complaint.guest = [[QUGuestManager sharedManager] fetchOrCreateEntityWithEntityID:JSON[@"guest"]];
		didUpdateAtLeastOneValue = YES;
	}

	return didUpdateAtLeastOneValue;
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
		 QUComplaint *complaint = [[self sharedManager] updateOrCreateEntityWithJSON:responseObject];

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
	[[self sharedManager] fetchSingleRemoteEntityAtEndpoint:endpoint successHandler:successHandler failureHandler:failureHandler];
}

+ (void)synchronizeAllMyComplaintsWithSuccessHandler:(void (^)(NSSet *))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	[[self sharedManager] fetchAllRemoteEntitiesAtEndpoint:QUAPIEndpointMyComplaints successHandler:successHandler failureHandler:failureHandler];
}

+ (void)deleteComplaintWithComplaintID:(NSNumber *)complaintID successHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
	DLOG(@"Delete Complaint %@", [complaintID stringValue]);

	NSString *endpoint = [QUAPIEndpointComplaint stringByReplacingOccurrencesOfString:@":complaintID" withString:[complaintID stringValue]];

	[[PFRESTManager sharedManager].operationManager DELETE:endpoint
												parameters:nil
												   success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 [[PFCoreDataManager sharedManager].managedObjectContext deleteObject:[[self sharedManager] fetchOrCreateEntityWithEntityID:complaintID]];
		 [[PFCoreDataManager sharedManager] save];

		 DLOG(@"Success!");
		 successHandler();
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 DLOG(@"Failure: %@", error);
		 failureHandler(error);
	 }];
}

@end
