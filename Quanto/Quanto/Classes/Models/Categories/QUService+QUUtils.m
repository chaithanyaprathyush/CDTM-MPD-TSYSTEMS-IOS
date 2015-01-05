//
//  QUService+QUUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUService+QUUtils.h"
#import "PFCoreDataManager.h"

@implementation QUService (QUUtils)

- (void)downloadPictureWithSuccessHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
    if (self.pictureURL && ![self.pictureURL isEqualToString:@""] && !self.pictureData) {
        dispatch_async(dispatch_queue_create("Download picture", nil), ^{
            NSData *pictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pictureURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pictureData = pictureData;
                [[PFCoreDataManager sharedManager] save];
                successHandler();
										  });
					   });
    } else if (self.pictureData) {
        successHandler();
    } else {
        DLOG(@"Error: no pictureURL found!");
        NSError *error = [NSError errorWithDomain:@"de.cdtm.quanto.ios" code:1 userInfo:@{@"message":@"No Picture URL specified"}];
        failureHandler(error);
    }
}

@end
