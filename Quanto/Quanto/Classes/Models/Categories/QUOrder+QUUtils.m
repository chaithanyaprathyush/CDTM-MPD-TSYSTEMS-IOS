//
//  QUOrder+QUUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrder+QUUtils.h"

const NSString *kQUOrderStatusOrderedString = @"Ordered";
const NSString *kQUOrderStatusOrderConfirmedString = @"Order confirmed";
const NSString *QUOrderStatusPaymentPendingString = @"Payment pending";
const NSString *QUOrderStatusTransactionClosedString = @"Transaction closed";
const NSString *QUOrderStatusUnknownString = @"Unknown";

@implementation QUOrder (QUUtils)

+ (QUOrderStatus)statusAsInt:(NSString *)statusAsString
{
    NSArray *statusStrings = @[@"ORDERED", @"ORDER CONFIRMED", @"PAYMENT PENDING", @"TRANSACTION CLOSED", @"UNKNOWN"];

	for (int i = 0; i < statusStrings.count; i++) {
		if ([statusStrings[i] isEqualToString:statusAsString]) {
			return i;
		}
	}

	return QUOrderStatusUnknown;
}

+ (NSString *)statusAsString:(QUOrderStatus)statusAsInt
{
	return [self statusStrings][statusAsInt];
}

+ (NSArray *)statusStrings
{
	return @[kQUOrderStatusOrderedString,kQUOrderStatusOrderConfirmedString,QUOrderStatusPaymentPendingString,QUOrderStatusTransactionClosedString,QUOrderStatusUnknownString];
}

- (NSString *)statusAsString
{
	return [QUOrder statusAsString:[self.status intValue]];
}

- (NSString *)lastModifiedAsString
{
    return [self.lastModifiedAt asEEEddMMMYYYY];
}

@end
