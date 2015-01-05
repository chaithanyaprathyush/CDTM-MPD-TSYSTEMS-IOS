//
//  ViewController.m
//  QuantoDoorDummy
//
//  Created by Pascal Fritzen on 02.01.15.
//  Copyright (c) 2015 Center for Digital Technology and Management. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

static NSString *QUAuthenticationServiceUUID = @"E5712DC1-F1C7-40AF-9A77-DC496386F4F7";
static NSString *QUAuthenticationServiceTokenCharacteristicUUID = @"7D695379-3ADC-49E8-A395-B1736B309C00";

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, retain) CBCentralManager *centralManager;

@property (nonatomic, retain) NSMutableArray *discoveredPeripherals;

@property (nonatomic, retain) NSMutableDictionary *lastMeasuredPeripheralRSSIs;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.discoveredPeripherals = [NSMutableArray array];
    self.lastMeasuredPeripheralRSSIs = [NSMutableDictionary dictionary];

	self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)updatePeripheralInformation
{
	NSString *peripheralInformation = [NSString stringWithFormat:@"Bluetooth-State: %@", [self centralManagerStateAsString:self.centralManager.state]];

	peripheralInformation = [peripheralInformation stringByAppendingString:@"\n\nDetected Peripherals:\n"];

	for (CBPeripheral *discoveredPeripheral in self.discoveredPeripherals) {
		peripheralInformation = [peripheralInformation stringByAppendingString:[NSString stringWithFormat:@"\t• %@", discoveredPeripheral.name]];
        
        // State
        peripheralInformation = [peripheralInformation stringByAppendingString:[NSString stringWithFormat:@"\n\t\tState:%@", [self peripheralStateAsString:discoveredPeripheral.state]]];
        
        // RSSI
        peripheralInformation = [peripheralInformation stringByAppendingString:[NSString stringWithFormat:@"\n\t\tRSSI:%@", [self lastMeasuredRSSIForPeripheral:discoveredPeripheral]]];
        
        // Services
        peripheralInformation = [peripheralInformation stringByAppendingString:[NSString stringWithFormat:@"\n\t\tServices:"]];
        
        for (CBService *service in discoveredPeripheral.services) {
            peripheralInformation = [peripheralInformation stringByAppendingString:[NSString stringWithFormat:@"\n\t\t\t• %@ (%@)", [self serviceUUIDStringAsHumanReadableString:service.UUID.UUIDString], service.UUID.UUIDString]];
            peripheralInformation = [peripheralInformation stringByAppendingString:[NSString stringWithFormat:@"\n\t\t\t\tCharacteristics:"]];

            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];

                peripheralInformation = [peripheralInformation stringByAppendingString:[NSString stringWithFormat:@"\n\t\t\t\t\t• %@", value]];
            }
        }
	}

	self.peripheralInformationTextView.text = peripheralInformation;
}

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

#pragma mark - <CBCentralManagerDelegate>

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	NSLog(@"New State: %d", central.state);
	[self updatePeripheralInformation];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	NSLog(@"Discovered Peripheral: '%@', ads: '%@', RSSI: '%@'", peripheral, advertisementData, RSSI);
	NSLog(@"State: %d", peripheral.state);

	if (![self.discoveredPeripherals containsObject:peripheral]) {
		[self.discoveredPeripherals addObject:peripheral];
	}

	NSLog(@"State: %d", peripheral.state);
	if (peripheral.state == CBPeripheralStateDisconnected) {
		[self.centralManager connectPeripheral:peripheral options:nil];
    } else {
        [peripheral readRSSI];
    }

	[self updatePeripheralInformation];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	peripheral.delegate = self;
	[peripheral discoverServices:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:peripheral selector:@selector(readRSSI) userInfo:nil repeats:YES];
    
    [self updatePeripheralInformation];
}

#pragma mark - <CBPeripheralDelegate>

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSLog(@"Did discover services for peripheral %@", peripheral);

	for (CBService *service in peripheral.services) {
		NSLog(@"Service (%@) %@", service.UUID.UUIDString, service);

		//if ([service.UUID isEqual:[CBUUID UUIDWithString:QUAuthenticationServiceUUID]]) {
			[peripheral discoverCharacteristics:nil forService:service];
		//}
	}
    
    [self updatePeripheralInformation];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	NSLog(@"Did discover characteristics for service: %@", service);

	for (CBCharacteristic *characteristic in service.characteristics) {
		NSLog(@"\tCharacteristic: %@", characteristic);
		[peripheral readValueForCharacteristic:characteristic];
	}
    
    [self updatePeripheralInformation];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	if (error) {
		NSLog(@"Error: %@", error);
	} else {
		NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];

		NSLog(@"Did update value for characteristic %@: %@", characteristic, value);
	}
    
    [self updatePeripheralInformation];
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"RSSI: %@", [RSSI stringValue]);

    [self.lastMeasuredPeripheralRSSIs setObject:RSSI forKey:peripheral];
    
    [self updatePeripheralInformation];
}

- (void)reset
{
    [self.centralManager stopScan];
    [self.scanningActivityIndicator stopAnimating];
    [self.startStopScanningButton setTitle:@"Start Scanning" forState:UIControlStateNormal];
    
    for (CBPeripheral *peripheral in self.discoveredPeripherals) {
        if (peripheral.state != CBPeripheralStateDisconnected) {
            [self.centralManager cancelPeripheralConnection:peripheral];
        }
    }
    
    [self.discoveredPeripherals removeAllObjects];
    
    [self updatePeripheralInformation];
    
    [self didTouchStartStopScanningButton:nil];
}

#pragma mark - IBActions

- (IBAction)didTouchStartStopScanningButton:(id)sender
{
	if ([self.scanningActivityIndicator isAnimating]) {
		[self.centralManager stopScan];
		[self.startStopScanningButton setTitle:@"Start Scanning" forState:UIControlStateNormal];
		[self.scanningActivityIndicator stopAnimating];
	} else {
		[self.centralManager scanForPeripheralsWithServices:nil options:nil];
		[self.startStopScanningButton setTitle:@"Stop Scanning" forState:UIControlStateNormal];
		[self.scanningActivityIndicator startAnimating];
	}
}

- (IBAction)didTouchResetButton:(id)sender
{
    [self reset];
}


@end
