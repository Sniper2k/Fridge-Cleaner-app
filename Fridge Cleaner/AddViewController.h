//
//  AddViewController.h
//  Fridge Cleaner
//
//  Created by Owner Owner on 04.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddViewControllerDelegate;

@interface AddViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    id<AddViewControllerDelegate> _delegate;
    IBOutlet UITableView* table;
    NSMutableArray* selectedIngridients;
}
@property (nonatomic, assign, readwrite) id<AddViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) UILocalizedIndexedCollation* collation;
@property (nonatomic, retain) NSMutableArray* selectedIngridients;
-(void) doneAction:(id) sender;
-(void) dealloc;
@end
