//
//  Data.h
//  Fridge Cleaner
//
//  Created by Owner Owner on 06.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Ingridient;

@interface Data : NSObject
{
    NSArray* ingridients;
    NSArray* recipes;
    NSMutableArray* selectedIngridients;
    NSArray* loadedRecipesArray;
    NSArray* loadedRecipesSections;
    NSArray* ingridientsLocalised;
    id selectedRecipe;
    BOOL recipesDirty;
}
@property (nonatomic, retain) NSArray* ingridients;
@property (nonatomic, retain) NSArray* ingridientsLocalized;
@property (nonatomic, retain) NSArray* recipes;
@property (nonatomic, retain) NSArray* loadedRecipesArray;
@property (nonatomic, retain) NSArray* loadedRecipesSections;
@property (nonatomic, retain) NSMutableArray* selectedIngridients;
@property (nonatomic, retain) id selectedRecipe;
@property (assign) BOOL recipesDirty;

-(Data*) init;
-(void) addIngridientToSelected:(Ingridient*) ing;
-(void) removeIngridientFromSelected:(Ingridient*) ing;
-(void) updateLoadedRecipes;
-(void) loadDatabase;
-(void) reload;
-(void) releaseData;
-(void) dealloc;
@end
