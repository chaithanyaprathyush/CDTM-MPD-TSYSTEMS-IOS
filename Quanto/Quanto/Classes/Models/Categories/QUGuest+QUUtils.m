//
//  QUGuest+QUUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUGuest+QUUtils.h"
#import "PFRESTManager.h"
#import "PFCoreDataManager.h"

@implementation QUGuest (QUUtils)

- (void)downloadAvatarWithSuccessHandler:(void (^)(void))successHandler failureHandler:(void (^)(NSError *))failureHandler
{
    if (self.avatarURL && ![self.avatarURL isEqualToString:@""] && !self.avatarData) {
        dispatch_async(dispatch_queue_create("Download avatar", nil), ^{
            NSString *fullAvatarURL = [NSString stringWithFormat:@"%@%@", [PFRESTManager hostAndPortURLAsString], self.avatarURL];
            NSData *avatarData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullAvatarURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarData = avatarData;
                [[PFCoreDataManager sharedManager] save];
                successHandler();
										  });
					   });
    } else if (self.avatarData) {
        successHandler();
    } else {
        DLOG(@"Error: no avatarURL found!");
        NSError *error = [NSError errorWithDomain:@"de.cdtm.quanto.ios" code:1 userInfo:@{@"message":@"No AvatarURL specified"}];
        failureHandler(error);
    }
}

@end
