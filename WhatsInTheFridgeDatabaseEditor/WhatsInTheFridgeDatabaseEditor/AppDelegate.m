//
//  AppDelegate.m
//  WhatsInTheFridgeDatabaseEditor
//
//  Created by Owner Owner on 11.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "AppDelegate.h"
#import "Ingridient.h"
#import "Recipe.h"

@implementation AppDelegate
@synthesize addButton,addedCombo,recipesCombo,ingridientsCombo,deleteButton, ingridients,recipes, ingridientsNames, recipesNames, selectedNames,selected, saveButton, amountsField, amountsShowField, selectedAdded, selectedString, addStringButton, deleteStringButton, stringsCombo, stringsField;

- (void)dealloc
{
    sqlite3_close(dbase);
    
    [recipes release];
    [ingridients release];
    [recipesNames release];
    [ingridientsNames release];
    [selectedNames release];
    
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    NSInteger res = [panel runModal];
    if (res == NSOKButton)
    {
        selected = -1;
        selectedAdded = -1;
        selectedString = -1;
        NSURL* fileName = [panel URL];
        [self loadDataFromDB:fileName];
        
        NSMutableArray* ar = [[NSMutableArray alloc] initWithCapacity:[ingridients count]];
        
        for(Recipe* ing in recipes)
            [ar addObject:ing.name];
        
        self.recipesNames = ar;
        [ar release];
        
        [self.recipesCombo addItemsWithObjectValues:self.recipesNames];
        
        ar = [[NSMutableArray alloc] initWithCapacity:[recipes count]];
        for(Ingridient* ing in ingridients)
            [ar addObject:ing.name];
        
        self.ingridientsNames = ar;
        [ar release];
        [self.ingridientsCombo addItemsWithObjectValues:self.ingridientsNames];
        
    }
}

-(void) loadDataFromDB:(NSURL *)url
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* path = [url path];
    sqlite3* database;
    
    if (sqlite3_open([path UTF8String],&database) == SQLITE_OK)
    {
        const char* sql_s = "SELECT pk FROM ingridients";
        sqlite3_stmt* statement;
        
        if (sqlite3_prepare_v2(database, sql_s, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int pk = sqlite3_column_int(statement, 0);
                
                Ingridient* ing = [[Ingridient alloc] initWithPrimaryKey:pk database: database];
                [array addObject:ing];
                [ing release];
            }
            self.ingridients = array;
            [array release];
        }
        
        array = [[NSMutableArray alloc] init];
        sql_s = "SELECT pk FROM recipes";
        sqlite3_finalize(statement);
        if (sqlite3_prepare_v2(database, sql_s, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int pk = sqlite3_column_int(statement, 0);
                
                Recipe* rec = [[Recipe alloc] initWithPrimaryKey:pk database:database];
                [array addObject:rec];
                [rec release];
            }
            
            self.recipes = array;
            [array release];
            
            sqlite3_finalize(statement);
        }
    }
    dbase = database;
}

-(void) refreshAddedData:(int)sel
{
    [addedCombo removeAllItems];
    [stringsCombo removeAllItems];
    
    NSArray* ing = [[recipes objectAtIndex:sel] ingridients];
    NSMutableArray* ar = [[NSMutableArray alloc] initWithCapacity:[ing count]];
    
    for (NSNumber* num in ing)
        [ar addObject:[[ingridients objectAtIndex:[num intValue]] name]];
    
    self.selectedNames = ar;
    [ar release];
    
    ar = [[NSMutableArray alloc] initWithCapacity:[ing count]];
    
    ing = [[recipes objectAtIndex:sel ] strings];
    for (NSString* str in ing)
        [ar addObject:str];
    
    [self.stringsCombo addItemsWithObjectValues:ar];
    [ar release];
    
    [self.addedCombo addItemsWithObjectValues:self.selectedNames];
        selected = sel;
    
    if ([selectedNames count] != 0)
    {
        [self.addedCombo selectItemAtIndex:0];
        Recipe* rec = [recipes objectAtIndex:sel];
        [self.amountsShowField setStringValue:[rec.amounts objectAtIndex:0]];
    }
    else
    {
        [self.addedCombo deselectItemAtIndex:0];
        [self.amountsShowField setStringValue:@""];
    }
}

-(IBAction)addPushed:(id)sender
{
    if ([ingridientsCombo indexOfSelectedItem] == -1 && [recipesCombo indexOfSelectedItem] == -1)
        return;
    
    Recipe* rec = [recipes objectAtIndex:selected];
    NSInteger index = [ingridientsCombo indexOfSelectedItem];
    
    if ([rec.ingridients indexOfObject:[NSNumber numberWithInteger:index]] == NSNotFound)
    {
        [rec.ingridients addObject:[NSNumber numberWithInteger:index]];
        [rec.amounts addObject:amountsField.stringValue];
        [self refreshAddedData:selected];
    }
}

-(IBAction)combo:(id)sender
{
    if ([recipesCombo indexOfSelectedItem] != selected)
    {
        [self refreshAddedData:(int)[recipesCombo indexOfSelectedItem]];
    }
    else if ([addedCombo indexOfSelectedItem] != selectedAdded)
    {
        selectedAdded =(int) [addedCombo indexOfSelectedItem];
        Recipe* rec =[recipes objectAtIndex:selected];
        [self.amountsShowField setStringValue:[rec.amounts objectAtIndex:selectedAdded]];
    }
    else if ([stringsCombo indexOfSelectedItem] != selectedString)
    {
        Recipe* rec = [recipes objectAtIndex:selected];
        if (selectedString!=-1)
        {
            [rec.strings replaceObjectAtIndex:selectedString withObject:stringsField.stringValue];
            [self.stringsCombo removeItemAtIndex:selectedString];
            [self.stringsCombo insertItemWithObjectValue:stringsField.stringValue atIndex:selectedString];
        }
        
        selectedString =(int) [stringsCombo indexOfSelectedItem];
        [self.stringsField setStringValue:[rec.strings objectAtIndex:selectedString]];
    }
}

-(IBAction)deletePushed:(id)sender
{
    if ([addedCombo indexOfSelectedItem] == -1 && [recipesCombo indexOfSelectedItem] == -1)
        return;
    
    Recipe* rec = [recipes objectAtIndex:selected];
    NSInteger index = [addedCombo indexOfSelectedItem];
    
    if ([rec.ingridients indexOfObject:[NSNumber numberWithInteger:index]] != NSNotFound)
    {
        [rec.ingridients removeObject:[NSNumber numberWithInteger:index]];
        [rec.amounts removeObject:[NSNumber numberWithInteger:index]];
        [self refreshAddedData:selected];
    }
}

-(IBAction)savePushed:(id)sender
{
    for (Ingridient* ing in ingridients)
        [ing.recipes removeAllObjects];
    
    for (int i=0;i<[recipes count];i++)
    {
        Recipe* rec = [recipes objectAtIndex:i];
        
        for (NSNumber* num in rec.ingridients)
        {
            Ingridient* ing =[ingridients objectAtIndex:[num intValue]];
            [ing.recipes addObject:[NSNumber numberWithInt:i]];
        }
        
        [rec updateDB:dbase Key:i+1];
    }
    
    for (Ingridient* ing in ingridients)
        [ing updateDB:dbase];
}

-(IBAction)addStringPushed:(id)sender
{
    Recipe* rec = [recipes objectAtIndex:selected];
    [rec.strings addObject:@"Type text"];
    [self.stringsCombo addItemWithObjectValue:@"Type Text"];
    [self.stringsCombo selectItemAtIndex:[rec.strings count]-1];
}

-(IBAction)deleteStringPushed:(id)sender
{
    Recipe* rec = [recipes objectAtIndex:selected];
    [rec.strings removeObjectAtIndex:selectedString];
    [self.stringsCombo removeItemAtIndex:selectedString];
    
    if ([rec.strings count]!=0)
    {
        selectedString = 0;
        [self.stringsCombo selectItemAtIndex:0];
        [self.stringsField setStringValue:[rec.strings objectAtIndex:0]];
    }
}
@end
