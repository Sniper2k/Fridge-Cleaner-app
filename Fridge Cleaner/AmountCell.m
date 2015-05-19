//
//  AmountCell.m
//  Fridge Cleaner
//
//  Created by Owner Owner on 23.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "AmountCell.h"

@implementation AmountCell
@synthesize titleLabel, descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
