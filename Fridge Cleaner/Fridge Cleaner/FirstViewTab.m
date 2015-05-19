//
//  FirstViewController.m
//  Fridge Cleaner
//
//  Created by Owner Owner on 01.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "FirstViewTab.h"
#import "IngridientCell.h"
#import "AddViewController.h"
#import "Global.h"
#import "Ingridient.h"
#import "Recipe.h"

@interface FirstViewTab ()

@end

@implementation FirstViewTab
@synthesize table;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Ingridients", @"Ingridients");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem* it = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAction:)] autorelease];
    
//    UINavigationController* nav= [[[UINavigationController alloc] initWithRootViewController:self] autorelease];
    
    
    [self.navigationItem setRightBarButtonItem:it];
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAction:)] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [g_data.selectedIngridients count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"IngridientCell";
    IngridientCell *cell=(IngridientCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"IngridientCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[IngridientCell class]])
                cell=(IngridientCell *)oneObject;
    }
    
    // Configure the cell...
    Ingridient* ing = [g_data.selectedIngridients objectAtIndex:[indexPath row]];
    
    cell.titleLabel.text = ing.name;
    cell.cellImage.image = [UIImage imageNamed:@"first.png"];
    return cell;
}

-(void) newIngridientsSelected:(NSArray *)selected
{
    if ([selected count] !=0)
    {
    
        for (IngridientAdd* add in selected)
        {
            if (add.add)
                [g_data addIngridientToSelected:add.ing];
            else
                [g_data removeIngridientFromSelected:add.ing];
        }
    
        [g_data updateLoadedRecipes];
    
        [self.table reloadData];
                
        g_data.recipesDirty = YES;
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)buttonAction:(id)sender
{
    AddViewController* view = [[[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil]autorelease];
    view.delegate = self;
    [[self navigationController] pushViewController:view animated:YES];
}

@end
