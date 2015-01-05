//
//  QUHotelServiceTableViewCell.m
//  Quanto
//
//  Created by Pascal Fritzen on 04.01.15.
//  Copyright (c) 2015 Pascal Fritzen. All rights reserved.
//

#import "QUHotelServiceTableViewCell.h"
#import "QUService+QUUtils.h"

@implementation QUHotelServiceTableViewCell

- (void)awakeFromNib
{
	// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (void)setService:(QUService *)service
{
	_service = service;

	self.nameLabel.text = service.name;
	self.priceLabel.text = [NSString stringWithFormat:@"%.2f €", [service.price floatValue]];

	[service downloadPictureWithSuccessHandler:^{
		 self.pictureImageView.image = [UIImage imageWithData:service.pictureData];
	 } failureHandler:^(NSError *error) {
		 NSLog(@"Fail!");
	 }];
}

@end
