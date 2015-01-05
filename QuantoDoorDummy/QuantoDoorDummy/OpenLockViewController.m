//
//  OpenLockViewController.m
//  QuantoDoorDummy
//
//  Created by Pascal Fritzen on 02.01.15.
//  Copyright (c) 2015 Center for Digital Technology and Management. All rights reserved.
//

#import "OpenLockViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

static NSString *QUAuthenticationServiceUUID = @"E5712DC1-F1C7-40AF-9A77-DC496386F4F7";
static NSString *QUAuthenticationServiceTokenCharacteristicUUID = @"7D695379-3ADC-49E8-A395-B1736B309C00";

@interface OpenLockViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, retain) CBCentralManager *centralManager;

@property (strong,nonatomic) NSMutableArray *discoveredPeripherals;

@end

@implementation OpenLockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.discoveredPeripherals = [NSMutableArray array];
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - <CBCentralManagerDelegate>

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"New State: %d", central.state);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
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
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

#pragma mark - <CBPeripheralDelegate>

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"Did discover services for peripheral %@", peripheral);
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Service (%@) %@", service.UUID.UUIDString, service);
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:QUAuthenticationServiceUUID]]) {
            NSLog(@"Discovering characteristics for QUAuthenticationService...");            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"Did discover characteristics for service: %@", service);
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"\tCharacteristic: %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:QUAuthenticationServiceTokenCharacteristicUUID]]) {
            NSString *authToken = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        
            NSLog(@"Did receive token: %@", authToken);
            
            [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.leftMiddleDoorImageView.frame = CGRectOffset(self.leftMiddleDoorImageView.frame, - self.leftMiddleDoorImageView.frame.size.width, 0);
                self.rightMiddleDoorImageView.frame = CGRectOffset(self.rightMiddleDoorImageView.frame, self.rightMiddleDoorImageView.frame.size.width, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:3.0f delay:5.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.leftMiddleDoorImageView.frame = CGRectOffset(self.leftMiddleDoorImageView.frame, self.leftMiddleDoorImageView.frame.size.width, 0);
                        self.rightMiddleDoorImageView.frame = CGRectOffset(self.rightMiddleDoorImageView.frame, - self.rightMiddleDoorImageView.frame.size.width, 0);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [peripheral readValueForCharacteristic:characteristic];
                            });
                        }
                    }];
                }
            }];
        }
    }
}

@end