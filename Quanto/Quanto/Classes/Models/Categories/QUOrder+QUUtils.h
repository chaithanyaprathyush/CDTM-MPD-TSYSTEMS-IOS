//
//  QUOrder+QUUtils.h
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrder.h"

typedef enum {
    QUOrderStatusOrdered = 0,
    QUOrderStatusOrderConfirmed,
    QUOrderStatusPaymentPending,
    QUOrderStatusTransactionClosed,
    QUOrderStatusUnknown
} QUOrderStatus;

@interface QUOrder (QUUtils)

+ (QUOrderStatus)statusAsInt:(NSString *)statusAsString;
+ (NSString *)statusAsString:(QUOrderStatus)statusAsInt;

- (NSString *)statusAsString;

- (NSString *)lastModifiedAsString;

@end
