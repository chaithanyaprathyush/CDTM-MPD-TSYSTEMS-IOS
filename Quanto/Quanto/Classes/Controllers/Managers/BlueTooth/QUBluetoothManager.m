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

static NSString *QUAuthenticationTokenServiceUUID = @"E5712DC1-F1C7-40AF-9A77-DC496386F4F7";
static NSString *QUAuthenticationTokenServiceAuthenticationTokenCharacteristicUUID = @"7D695379-3ADC-49E8-A395-B1736B309C00";

@interface QUBluetoothManager () <CBPeripheralManagerDelegate>

@property (nonatomic, retain) CBPeripheralManager *peripheralManager;

@property (nonatomic, retain) CBMutableService *authenticationTokenService;
@property (nonatomic, retain) CBMutableCharacteristic *authenticationTokenCharacteristic;
@property (nonatomic, retain) NSData *authenticationTokenData;

@property (nonatomic) BOOL isAdvertisingServices;

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

+ (void)setAuthenticationToken:(NSString *)authenticationToken
{
	[self sharedManager].authenticationTokenData = [authenticationToken dataUsingEncoding:NSUTF8StringEncoding];
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		// Setup peripheral manager
		self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];

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
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
	if (error) {
		DLOG(@"Error advertising: %@", [error localizedDescription]);
        self.isAdvertisingServices = NO;
	} else {
		DLOG(@"Successfully started advertising...");
        self.isAdvertisingServices = YES;
	}
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
	if ([request.characteristic.UUID isEqual:self.authenticationTokenCharacteristic.UUID]) {
		DLOG(@"Token requested!");

		if (request.offset > self.authenticationTokenData.length) {
			DLOG(@"Offset!");
			[self.peripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
			return;
		} else {
			CWStatusBarNotification *notifiaction = [CWStatusBarNotification new];
			[notifiaction displayNotificationWithMessage:@"Token sent" forDuration:1.0f];
            
			request.value = [self.authenticationTokenData subdataWithRange:NSMakeRange(request.offset, self.authenticationTokenData.length - request.offset)];
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

+ (BOOL)isAdvertisingServices
{
    return [self sharedManager].isAdvertisingServices;
}

+ (void)startAdvertisingServices
{
    [[self sharedManager] startAdvertisingServices];
}

- (void)startAdvertisingServices
{
    if (self.isAdvertisingServices) {
        return;
    }
    
    // Publish services
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[self.authenticationTokenService.UUID]}];
}

+ (void)stopAdvertisingServices
{
    [[self sharedManager] stopAdvertisingServices];
}

- (void)stopAdvertisingServices
{
    if (!self.isAdvertisingServices) {
        return;
    }
    
    // Publish services
    [self.peripheralManager stopAdvertising];
}

@end
