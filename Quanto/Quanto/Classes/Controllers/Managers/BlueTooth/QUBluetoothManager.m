//
//  QUBluetoothManager.m
//  Quanto
//
//  Created by Pascal Fritzen on 02.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUBluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CWStatusBarNotification.h"
#import "PFAuthenticationManager.h"

static NSString *QUAuthenticationTokenServiceUUID = @"E5712DC1-F1C7-40AF-9A77-DC496386F4F7";
static NSString *QUAuthenticationTokenServiceAuthenticationTokenCharacteristicUUID = @"7D695379-3ADC-49E8-A395-B1736B309C00";

@interface QUBluetoothManager () <CBPeripheralManagerDelegate>

@property (nonatomic, retain) CBPeripheralManager *peripheralManager;

@property (nonatomic, retain) CBMutableService *authenticationTokenService;
@property (nonatomic, retain) CBMutableCharacteristic *authenticationTokenCharacteristic;

@property (nonatomic) BOOL isAuthenticationServiceEnabled;

@end

@implementation QUBluetoothManager

#pragma mark - Singleton

+ (QUBluetoothManager *)sharedManager
{
	static QUBluetoothManager *sharedManager = nil;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		sharedManager = [QUBluetoothManager new];
	});

	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];

		// Setup characteristic
		CBUUID *tokenCharacteristicUUID = [CBUUID UUIDWithString:QUAuthenticationTokenServiceAuthenticationTokenCharacteristicUUID];
		self.authenticationTokenCharacteristic = [[CBMutableCharacteristic alloc] initWithType:tokenCharacteristicUUID
																					properties:CBCharacteristicPropertyRead
																						 value:nil
																				   permissions:CBAttributePermissionsReadable];

		// Setup service
		CBUUID *authenticationServiceUUID = [CBUUID UUIDWithString:QUAuthenticationTokenServiceUUID];
		self.authenticationTokenService = [[CBMutableService alloc] initWithType:authenticationServiceUUID primary:YES];
		self.authenticationTokenService.characteristics = @[self.authenticationTokenCharacteristic];
	}
	return self;
}

#pragma mark - <CBPeripheralManagerDelegate>

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
	DLOG(@"New State: %ld", peripheral.state);

	if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
		// Add service
		[self.peripheralManager addService:self.authenticationTokenService];
	}
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
	if (error) {
		DLOG(@"Error adding service: %@", [error localizedDescription]);
	} else {
		DLOG(@"Successfully added service: %@", service.UUID.UUIDString);
		[self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[self.authenticationTokenService.UUID]}];
	}
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
	if (error) {
		DLOG(@"Error advertising: %@", [error localizedDescription]);
		self.isAuthenticationServiceEnabled = NO;
	} else {
		DLOG(@"Successfully started advertising...");
		self.isAuthenticationServiceEnabled = YES;
	}
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
	if ([request.characteristic.UUID isEqual:self.authenticationTokenCharacteristic.UUID]) {
		DLOG(@"Token requested!");

		NSString *authenticationToken = [PFAuthenticationManager storedAuthenticationToken];
		NSData *authenticationTokenData = [authenticationToken dataUsingEncoding:NSUTF8StringEncoding];

		if (request.offset > authenticationTokenData.length) {
			DLOG(@"Offset!");
			[self.peripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
			return;
		} else {
			CWStatusBarNotification *notifiaction = [CWStatusBarNotification new];
			[notifiaction displayNotificationWithMessage:@"Token sent" forDuration:1.0f];

			request.value = [authenticationTokenData subdataWithRange:NSMakeRange(request.offset, authenticationTokenData.length - request.offset)];
			[self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
		}
	}
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
	DLOG(@"Central '%@' subscribed to characteristic '%@'", central, characteristic);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
	DLOG(@"Central '%@' UNsubscribed to characteristic '%@'", central, characteristic);
}

#pragma mark - Advertizing Utils
/*
 + (void)didChangeAuthenticationToken:(NSString *)authenticationToken
   {
    [[self sharedManager].peripheralManager updateValue:[authenticationToken?:@"" dataUsingEncoding:NSUTF8StringEncoding]
                                      forCharacteristic:[self sharedManager].authenticationTokenCharacteristic
                                   onSubscribedCentrals:nil];
   }

 + (BOOL)isAuthenticationServiceEnabled
   {
    return [self sharedManager].isAuthenticationServiceEnabled;
   }

 + (void)enableAuthenticationService
   {
    [[self sharedManager] enableAuthenticationService];
   }

   - (void)enableAuthenticationService
   {
    if (self.isAuthenticationServiceEnabled) {
        return;
    }

    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        // Add service
        [self.peripheralManager addService:self.authenticationTokenService];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self enableAuthenticationService];
        });
    }
   }

 + (void)disableAuthenticationService
   {
    [[self sharedManager] disableAuthenticationService];
   }

   - (void)disableAuthenticationService
   {
    if (!self.isAuthenticationServiceEnabled) {
        return;
    }

    [self.peripheralManager stopAdvertising];
    [self.peripheralManager removeService:self.authenticationTokenService];
    self.isAuthenticationServiceEnabled = NO;
   }*/

@end
