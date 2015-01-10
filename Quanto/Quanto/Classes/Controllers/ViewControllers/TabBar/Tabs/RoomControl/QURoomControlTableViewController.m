//
//  QURoomControlTableViewController.m
//  Quanto
//
//  Created by Pascal Fritzen on 10.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QURoomControlTableViewController.h"

@implementation QURoomControlTableViewController

- (IBAction)didTouchBedroomLightsButton:(id)sender
{
    UIButton *button = sender;
    
    button.selected = !button.selected;
    
    UILabel *label = nil;
    int row = 0;
    if (button == self.bedroomLightsButton) {
        label = self.bedroomLightsLabel;
        row = 0;
    } else if (button == self.bathroomLightsButton) {
        label = self.bathroomLightsLabel;
        row = 1;
    } else if (button == self.livingRoomLightsButton) {
        label = self.livingRoomLightsLabel;
        row = 2;
    } else if (button == self.musicLightsButton) {
        label = self.musicLightsLabel;
        row = 3;
    }
    
    label.textColor = button.selected ? [UIColor whiteColor] : [UIColor darkerDarkGrayColor];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    cell.contentView.backgroundColor = button.selected ? [UIColor peterRiverColor] : [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 4) {
        return;
    }
    
    UILabel *label = @[self.bedroomLightsLabel, self.bathroomLightsLabel, self.livingRoomLightsLabel, self.musicLightsLabel][indexPath.row];
    
    UIButton *button = @[self.bedroomLightsButton, self.bathroomLightsButton, self.livingRoomLightsButton, self.musicLightsButton][indexPath.row];

    button.selected = !button.selected;
        label.textColor = button.selected ? [UIColor whiteColor] : [UIColor darkerDarkGrayColor];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = button.selected ? [UIColor peterRiverColor] : [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 4) {
        return;
    }
    
    UILabel *label = @[self.bedroomLightsLabel, self.bathroomLightsLabel, self.livingRoomLightsLabel, self.musicLightsLabel][indexPath.row];
    
    UIButton *button = @[self.bedroomLightsButton, self.bathroomLightsButton, self.livingRoomLightsButton, self.musicLightsButton][indexPath.row];
    
    button.selected = NO;
    label.textColor = [UIColor darkerDarkGrayColor];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = button.selected ? [UIColor peterRiverColor] : [UIColor whiteColor];
}

@end
