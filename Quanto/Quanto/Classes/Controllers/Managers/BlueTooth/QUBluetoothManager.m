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

static NSString *QUArduinoUARTServiceUUID       = @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
static NSString *QUArduinoTXCharacteristicUUID  = @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"; // Write
static NSString *QUArduinoRXCharacteristicUUID  = @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"; // Read

@interface QUBluetoothManager () <CBCentralManagerDelegate, CBPeripheralDelegate> // CBPeripheralManagerDelegate

@property (nonatomic, retain) CBCentralManager *centralManager;
@property (nonatomic, retain) NSMutableArray *discoveredPeripherals;
@property (nonatomic, retain) NSMutableDictionary *lastMeasuredPeripheralRSSIs;

@property (nonatomic, retain) CBCharacteristic *txCharacteristic;

@property (nonatomic, retain) CBPeripheralManager *peripheralManager;

@property (nonatomic, retain) CBMutableService *authenticationTokenService;
@property (nonatomic, retain) CBMutableCharacteristic *authenticationTokenCharacteristic;

@property (nonatomic, retain) NSMutableArray *lastMeasuredRSSIs;

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
		self.discoveredPeripherals = [NSMutableArray array];
		self.lastMeasuredPeripheralRSSIs = [NSMutableDictionary dictionary];
        self.lastMeasuredRSSIs = [NSMutableArray arrayWithCapacity:5];

		self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

		/*
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
		   self.authenticationTokenService.characteristics = @[self.authenticationTokenCharacteristic];*/
	}
	return self;
}

#pragma mark - <CBCentralManagerDelegate>

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	NSLog(@"New State: %ld", central.state);

	switch (central.state) {
	case CBCentralManagerStatePoweredOn:
		[self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:QUArduinoUARTServiceUUID]] options:nil];
		// [self.centralManager scanForPeripheralsWithServices:nil options:nil];

		break;

	default:
		break;
	}
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	NSLog(@"Discovered Peripheral: '%@', ads: '%@', RSSI: '%@'", peripheral, advertisementData, RSSI);
	NSLog(@"State: %ld", peripheral.state);

	if (![self.discoveredPeripherals containsObject:peripheral]) {
		[self.discoveredPeripherals addObject:peripheral];
	}

//    [self checkIfToConnectToPeripheral:peripheral];
    
    NSLog(@"RSSI: %lld", [RSSI longLongValue]);

    if (peripheral.state == CBPeripheralStateDisconnected) {
        [self.centralManager connectPeripheral:peripheral options:nil];
    } else {
        [peripheral readRSSI];
    }
}

- (void)checkIfToConnectToPeripheral:(CBPeripheral *)peripheral
{
	[peripheral readRSSI];

	NSLog(@"State: %ld", peripheral.state);
	if (peripheral.state == CBPeripheralStateDisconnected) {
		[self.centralManager connectPeripheral:peripheral options:nil];
	} else {
		[peripheral readRSSI];
	}
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	peripheral.delegate = self;
	[peripheral discoverServices:nil];
	// [self.centralManager cancelPeripheralConnection:peripheral];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	//  });

	//[NSTimer scheduledTimerWithTimeInterval:3.0f target:peripheral selector:@selector(readRSSI) userInfo:nil repeats:YES];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	[self.centralManager cancelPeripheralConnection:peripheral];
	// [self.discoveredPeripherals removeObject:peripheral];
	[self.centralManager connectPeripheral:peripheral options:nil];

	NSLog(@"disconnected: %@", error);
}

#pragma mark - <CBPeripheralDelegate>

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSLog(@"Did discover services for peripheral %@", peripheral);

	for (CBService *service in peripheral.services) {
		NSLog(@"Service (%@) %@", service.UUID.UUIDString, service);

		// if ([service.UUID isEqual:[CBUUID UUIDWithString:QUAuthenticationServiceUUID]]) {
		[peripheral discoverCharacteristics:nil forService:service];
		// }
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	NSLog(@"Did discover characteristics for service: %@", service);

	for (CBCharacteristic *characteristic in service.characteristics) {
		NSLog(@"\tCharacteristic: %@", characteristic);

        if ([characteristic.UUID.UUIDString isEqualToString:QUArduinoTXCharacteristicUUID]) {
            self.txCharacteristic = characteristic;
            
            [peripheral readRSSI];

/*		[NSTimer scheduledTimerWithTimeInterval:5.0f
										 target:self
									   selector:@selector(writeToken:)
									   userInfo:@{@"peripheral":peripheral, @"characteristic":characteristic}
										repeats:YES]; */
        }
	}
}

- (void)writeCommand:(NSString *)command toPeripheral:(CBPeripheral *)peripheral
{
//	CBPeripheral *peripheral = timer.userInfo[@"peripheral"];
//	CBCharacteristic *characteristic = timer.userInfo[@"characteristic"];
    
//    NSString *openCommand = @"OPEN"; //[PFAuthenticationManager storedAuthenticationToken];
//    UInt8 buf[1] = {0};
//    NSData *authenticationTokenData = [NSData dataWithBytes:buf length:1];
    
    NSLog(@"%@", command);
    
    NSData *commandData = [command dataUsingEncoding:NSUTF8StringEncoding];
    [peripheral writeValue:commandData forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	if (error) {
		NSLog(@"Error: %@", error);
	} else {
		NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];

		NSLog(@"Did update value for characteristic %@: %@", characteristic, value);
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
	NSLog(@"RSSI: %i", [RSSI intValue]);

	[self.lastMeasuredPeripheralRSSIs setObject:RSSI forKey:peripheral];
    
    [self addLastMeasuredRSSI:RSSI];
    
    if ([RSSI intValue] > - 70) {
        [self writeCommand:@"CLOSE" toPeripheral:peripheral];
        [self reset];
    } else if ([RSSI intValue] > - 80) {
        [self writeCommand:@"NEARBY" toPeripheral:peripheral];
    } else {
        [self writeCommand:@"FAR" toPeripheral:peripheral];
    }
    
    [peripheral readRSSI];
}

- (void)addLastMeasuredRSSI:(NSNumber *)lastMeasuredRSSI
{
    [self.lastMeasuredRSSIs addObject:lastMeasuredRSSI];
    
    if (self.lastMeasuredRSSIs.count > 5) {
        [self.lastMeasuredRSSIs removeObjectAtIndex:0];
    }
}

- (float)average
{
    if (self.lastMeasuredRSSIs.count == 0) {
        return 0.0f;
    }
    
    float sum = 0.0f;
    
    for (NSNumber *lastMeasuredRRSI in self.lastMeasuredRSSIs) {
        sum += [lastMeasuredRRSI floatValue];
    }
    
    return sum / self.lastMeasuredRSSIs.count;
}

- (void)reset
{
	[self.centralManager stopScan];

	for (CBPeripheral *peripheral in self.discoveredPeripherals) {
		if (peripheral.state != CBPeripheralStateDisconnected) {
			[self.centralManager cancelPeripheralConnection:peripheral];
		}
	}

	[self.discoveredPeripherals removeAllObjects];
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - Utils

- (NSString *)lastMeasuredRSSIForPeripheral:(CBPeripheral *)peripheral
{
	return [self.lastMeasuredPeripheralRSSIs[peripheral] stringValue];
}

- (NSString *)centralManagerStateAsString:(CBCentralManagerState)state
{
	return @[@"CBCentralManagerStateUnknown",
			 @"CBCentralManagerStateResetting",
			 @"CBCentralManagerStateUnsupported",
			 @"CBCentralManagerStateUnauthorized",
			 @"CBCentralManagerStatePoweredOff",
			 @"CBCentralManagerStatePoweredOn"][state];
}

- (NSString *)peripheralStateAsString:(CBPeripheralState)state
{
	return @[@"CBPeripheralStateDisconnected",
			 @"CBPeripheralStateConnecting",
			 @"CBPeripheralStateConnected"][state];
}

- (NSString *)serviceUUIDStringAsHumanReadableString:(NSString *)UUIDString
{
	if ([UUIDString isEqual:@"180F"]) {
		return @"Battery [Bluetooth Standard]";
	} else if ([UUIDString isEqual:@"1805"]) {
		return @"Current Time [Bluetooth Standard]";
	} else if ([UUIDString isEqual:@"D0611E78-BBB4-4591-A5F8-487910AE4366"]) {
		return @"Continuity [Apple Proprietary]";
	} else if ([UUIDString isEqual:@"E5712DC1-F1C7-40AF-9A77-DC496386F4F7"]) {
		return @"Quanto-Lock [Quanto Proprietary]";
	} else {
		return UUIDString;
	}
}


// old


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

@end
