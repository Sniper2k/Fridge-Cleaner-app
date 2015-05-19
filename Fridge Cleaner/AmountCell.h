//
//  AmountCell.h
//  Fridge Cleaner
//
//  Created by Owner Owner on 23.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmountCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *descriptionLabel;
}
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@end
