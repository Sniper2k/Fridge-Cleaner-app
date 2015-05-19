//
//  Ingridient.h
//  Fridge Cleaner
//
//  Created by Owner Owner on 07.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Ingridient : NSObject
{
    int key;
    NSString* name;
    NSMutableArray* recipes;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSMutableArray* recipes;
@property (assign) int key;

-(Ingridient*) init;
-(Ingridient*) initWithPrimaryKey:(int) pk database:(sqlite3*) db;
-(void) updateDB:(sqlite3*) db;
-(void) dealloc;
@end

@interface IngridientAdd : NSObject
{
    Ingridient* ing;
    BOOL add;
}
@property (nonatomic,retain) Ingridient* ing;
@property (assign) BOOL add;

-(IngridientAdd*) initWithIngridient:(Ingridient*) ingridient Add:(BOOL) bAdd;
-(void) dealloc;
@end