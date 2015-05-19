//
//  AddViewController.m
//  Fridge Cleaner
//
//  Created by Owner Owner on 04.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "AddViewController.h"
#import "Global.h"
#import "Ingridient.h"

@interface AddViewController ()
-(void) addNewIngridient:(IngridientAdd*) add;
@end

@implementation AddViewController
@synthesize delegate = _delegate, table;
@synthesize collation;
@synthesize selectedIngridients;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.selectedIngridients = [[NSMutableArray alloc] init];
        self.title = NSLocalizedString(@"Choose", @"Choose");
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* it = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
    [self.navigationItem setLeftBarButtonItem:it];
    
    self.collation = [UILocalizedIndexedCollation currentCollation];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (Ingridient* ing in g_data.selectedIngridients)
    {
        
        NSInteger sectionNumber = [collation sectionForObject:ing collationStringSelector:@selector(name)];
        NSArray* array = [g_data.ingridientsLocalized objectAtIndex:sectionNumber];
        NSInteger index = [array indexOfObject:ing];
        NSIndexPath* path = [NSIndexPath indexPathForItem:index inSection:sectionNumber];
        [table selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// The number of sections is the same as the number of titles in the collation.
    return [[collation sectionTitles] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	// The number of time zones in the section is the count of the array associated with the section in the sections array.
	NSArray *timeZonesInSection = [g_data.ingridientsLocalized objectAtIndex:section];
	
    return [timeZonesInSection count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"DefaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSArray *namesInSection = [g_data.ingridientsLocalized objectAtIndex:indexPath.section];
    
    Ingridient* ing = [namesInSection objectAtIndex:indexPath.row];
    cell.textLabel.text = ing.name;
    // Configure the cell...
    
	// Configure the cell with the time zone's name.
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[collation sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [collation sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [collation sectionForSectionIndexTitleAtIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *namesInSection = [g_data.ingridientsLocalized objectAtIndex:indexPath.section];
    Ingridient* ing = [namesInSection objectAtIndex:indexPath.row];
    IngridientAdd* add = [[IngridientAdd alloc] initWithIngridient:ing Add:NO];
    [self addNewIngridient:add];
    [add release];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *namesInSection = [g_data.ingridientsLocalized objectAtIndex:indexPath.section];
    Ingridient* ing = [namesInSection objectAtIndex:indexPath.row];
    IngridientAdd* add = [[IngridientAdd alloc] initWithIngridient:ing Add:YES];
    [self addNewIngridient:add];
    [add release];
}

-(void) doneAction:(id)sender
{
    [self.delegate newIngridientsSelected:selectedIngridients];
}
        
-(void) addNewIngridient:(IngridientAdd *)add
{
    if ([selectedIngridients containsObject:add])
    {
        [selectedIngridients removeObject:add];
    }
    else
    {
        add.add=!add.add;
        [selectedIngridients addObject:add];
    }
}

-(void) dealloc
{
    self.collation=nil;
    [selectedIngridients release];
    
    [super dealloc];
}
@end
