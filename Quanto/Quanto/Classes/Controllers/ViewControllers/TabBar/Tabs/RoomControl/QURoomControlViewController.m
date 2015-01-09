//
//  QURoomControlViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 03.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QURoomControlViewController.h"

typedef enum {
	kQIVICONLightBulbStateOn,
	kQIVICONLightBulbStateOff
} QIVICONLightBulbState;

@interface QURoomControlViewController ()

@property (nonatomic) QIVICONLightBulbState bedroomLightState;
@property (nonatomic) QIVICONLightBulbState bathroomLightState;
@property (nonatomic) float roomTemperature;

@end

@implementation QURoomControlViewController

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	[self.bedroomLightButton makeAlmostSquared];
	[self.bathroomLightButton makeAlmostSquared];
	[self.roomTemperatureButton makeAlmostSquared];
	[self.turnOffAllButton makeAlmostSquared];
    
    self.turnOffAllButton.enabled = self.bedroomLightButton.selected || self.bathroomLightButton.selected;
}

#pragma mark - IBActions

- (IBAction)didTouchBedroomLightButton:(id)sender
{
    self.bedroomLightButton.selected = !self.bedroomLightButton.selected;
    
    self.turnOffAllButton.enabled = self.bedroomLightButton.selected || self.bathroomLightButton.selected;
}

- (void)didTouchBathroomLightButton:(id)sender
{
    self.bathroomLightButton.selected = !self.bathroomLightButton.selected;

    self.turnOffAllButton.enabled = self.bedroomLightButton.selected || self.bathroomLightButton.selected;
}

- (void)didTouchRoomTemperatureButton:(id)sender
{

}

- (void)didTouchTurnOffAllButton:(id)sender
{
    self.bedroomLightButton.selected = NO;
    self.bathroomLightButton.selected = NO;
    self.turnOffAllButton.enabled = self.bedroomLightButton.selected || self.bathroomLightButton.selected;
}

@end
