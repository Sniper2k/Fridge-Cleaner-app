//
//  Data.m
//  Fridge Cleaner
//
//  Created by Owner Owner on 06.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "Data.h"
#import "Ingridient.h"
#import "Recipe.h"
#import <sqlite3.h>

#define MAX_NOT_INCLUDED 5

@interface Data ()

@end

@implementation Data
@synthesize selectedIngridients, selectedRecipe, recipes, ingridients, loadedRecipesArray, loadedRecipesSections, ingridientsLocalized, recipesDirty;

-(Data*) init
{
    self = [super init];
    if (self)
    {
        recipesDirty=NO;
        /*
        NSMutableArray* ar = [[NSMutableArray alloc] initWithCapacity:10];
        Ingridient* ing = [[Ingridient alloc] init];
        ing.name=@"sssss";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"aaaaa";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"rsd";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"aasss";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"ssrfv";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"assss";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"sqdfc";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"12134";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"qwvds";
        [ar addObject:ing];
        ing = [[Ingridient alloc] init];
        ing.name=@"vasss";
        [ar addObject:ing];
        */
        self.ingridients = [[NSArray alloc] init];
//        [ar release];
        
        self.selectedIngridients = [[NSMutableArray alloc]init];
        self.recipes = [[NSArray alloc] init];
        self.selectedRecipe = nil;
        self.loadedRecipesArray = [[NSArray alloc] init];
        self.selectedRecipe= nil;
    }
    return self;
}

-(void) addIngridientToSelected:(Ingridient*)ing
{
    for (NSNumber* num in ing.recipes)
    {
        Recipe* rec = [recipes objectAtIndex:[num intValue]];
        rec.included--;
    }
    
    ing.included = YES;
    [selectedIngridients addObject:ing];
}

-(void) removeIngridientFromSelected:(Ingridient*)ing
{
    for (NSNumber* num in ing.recipes)
    {
        Recipe* rec = [recipes objectAtIndex:[num intValue]];
        rec.included++;
    }
    
    ing.included = NO;
    [selectedIngridients removeObject:ing];
}

-(void) updateLoadedRecipes
{
    int max = 0;
    for (Recipe* rec in recipes)
        if (rec.included>max && rec.included<[rec.ingridients count])
            max = rec.included;
    
    if (max > MAX_NOT_INCLUDED)
        max = MAX_NOT_INCLUDED;
    
    max++;
    int count[max];
    
    for (char i=0;i<max;i++)
        count[i]=0;
    
    for (Recipe* rec in recipes)
        if (rec.included<max && rec.included<[rec.ingridients count])
            count[rec.included]++;
    
    NSMutableArray* newSectionsArray = [[NSMutableArray alloc] initWithCapacity:max];
    
    for (char i=0;i<max;i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count[i]];
		[newSectionsArray addObject:array];
        [array release];
    }
    
    int index;
    for (Recipe* rec in recipes)
		if (rec.included<max && rec.included<[rec.ingridients count])
        {
            NSInteger sectionNumber = rec.included;
            NSMutableArray *section = [newSectionsArray objectAtIndex:sectionNumber];
            [section addObject:rec];
        }
    
    self.loadedRecipesArray = newSectionsArray;
    [newSectionsArray release];
    
    NSMutableArray* newSectionNames = [[NSMutableArray alloc] initWithCapacity:[loadedRecipesArray count]];
    [newSectionNames addObject:@"All Ingridients present"];
    
    for (index = 1;index<max;index++)
    {
        [newSectionNames addObject:[NSString stringWithFormat:@"%i ingridient missing",index]];
    }
    
    self.loadedRecipesSections = newSectionNames;
    [newSectionNames release];
}

-(void) loadDatabase
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"data.sqlite"];
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
    
    sqlite3_close(database);
    
    UILocalizedIndexedCollation* collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (index = 0; index < sectionTitlesCount; index++)
    {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
    
    for (Ingridient* ing in ingridients)
    {
		
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [collation sectionForObject:ing collationStringSelector:@selector(name)];
		
		// Get the array for the section.
		NSMutableArray *sectionTimeZones = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the time zone to the section.
		[sectionTimeZones addObject:ing];
	}
    
    for (index = 0; index < sectionTitlesCount; index++)
    {
		
		NSMutableArray *timeZonesArrayForSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedTimeZonesArrayForSection = [collation sortedArrayFromArray:timeZonesArrayForSection collationStringSelector:@selector(name)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedTimeZonesArrayForSection];
	}
	
	self.ingridientsLocalized = newSectionsArray;
	[newSectionsArray release];
    
    collation = nil;
}

-(void) reload
{
    [self loadDatabase];
    if (selectedRecipe)
        self.selectedRecipe = [recipes objectAtIndex:[selectedRecipe intValue]];
    
    NSArray* array = self.selectedIngridients;
    self.selectedIngridients = [[NSMutableArray alloc] init];
    for (NSNumber* num in array)
    {
        Ingridient* ing = [ingridients objectAtIndex:[num intValue]];
        [self addIngridientToSelected:ing];
    }
    [array release];
}

-(void) releaseData
{
    if (selectedRecipe)
        self.selectedRecipe = [NSNumber numberWithInt:[recipes indexOfObject:selectedRecipe]];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (Ingridient* ing in selectedIngridients)
        [array addObject:[NSNumber numberWithInt:ing.key]];
    
    self.selectedIngridients = array;
    [array release];
    
    self.ingridients = [[NSArray alloc] init];
    self.recipes = [[NSArray alloc] init];
    self.loadedRecipesArray = [[NSMutableArray alloc] init];
}

-(void) dealloc
{
    [selectedRecipe release];
    [selectedIngridients release];
    [recipes release];
    [ingridients release];
    [loadedRecipesArray release];
    [loadedRecipesSections release];
    [ingridientsLocalized release];
    
    [super dealloc];
}

@end
