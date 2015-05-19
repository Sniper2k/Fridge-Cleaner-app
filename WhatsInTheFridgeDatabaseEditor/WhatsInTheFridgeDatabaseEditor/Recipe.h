//
//  Recipe.h
//  Fridge Cleaner
//
//  Created by Owner Owner on 10.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Recipe : NSObject
{
    int included;
    NSMutableArray* ingridients;
    NSMutableArray* amounts;
    NSMutableArray* strings;
    NSString* name;
    NSString* smallDescription;
}
@property (nonatomic, retain) NSMutableArray* ingridients;
@property (nonatomic, retain) NSMutableArray* amounts;
@property (nonatomic, retain) NSMutableArray* strings;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* smallDescription;
@property (assign) int included;

-(Recipe*) init;
-(Recipe*) initWithPrimaryKey:(int) pk database:(sqlite3*) db;
-(void) updateDB:(sqlite3*) db Key:(int) key;
-(void) dealloc;
@end
