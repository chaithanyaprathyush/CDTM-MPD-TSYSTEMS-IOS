//
//  QUOrder+QUUtils.m
//  Quanto
//
//  Created by Pascal Fritzen on 05.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUOrder+QUUtils.h"

const NSString *kQUOrderStatusOrderedString = @"ORDERED";
const NSString *kQUOrderStatusOrderConfirmedString = @"ORDER CONFIRMED";
const NSString *QUOrderStatusPaymentPendingString = @"PAYMENT PENDING";
const NSString *QUOrderStatusTransactionClosedString = @"TRANSACTION CLOSED";
const NSString *QUOrderStatusUnknownString = @"UNKNOWN";

@implementation QUOrder (QUUtils)

+ (QUOrderStatus)statusAsInt:(NSString *)statusAsString
{
	NSArray *statusStrings = [self statusStrings];

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

@end
