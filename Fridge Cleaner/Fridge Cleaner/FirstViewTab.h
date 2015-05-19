//
//  FirstViewController.h
//  Fridge Cleaner
//
//  Created by Owner Owner on 01.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewTab : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* table;
    
}
@property (nonatomic, retain) IBOutlet UITableView* table;

-(IBAction) buttonAction:(id) sender;
-(void) newIngridientsSelected:(NSArray*) selected;
@end
