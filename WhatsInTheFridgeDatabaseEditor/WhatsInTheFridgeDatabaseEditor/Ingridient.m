//
//  Ingridient.m
//  Fridge Cleaner
//
//  Created by Owner Owner on 07.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "Ingridient.h"

static sqlite3_stmt* init_statement=nil;
static sqlite3_stmt* update_statement=nil;
@implementation IngridientAdd
@synthesize ing,add;


-(IngridientAdd*) initWithIngridient:(Ingridient *)ingridient Add:(BOOL)bAdd
{
    self = [super init];
    if (self)
    {
        self.ing= ingridient;
        self.add =bAdd;
    }
    return self;
}

-(void) dealloc
{
    [ing release];
    
    [super dealloc];
}

@end

@implementation Ingridient
@synthesize name, recipes, key;

-(Ingridient*) init
{
    self = [super init];
    if (self)
    {
        self.name =@"";
        self.recipes =[[NSMutableArray alloc] init];
        self.key = 0;
    }
    return self;
}

-(Ingridient*) initWithPrimaryKey:(int)pk database:(sqlite3 *)db
{
    self = [super init];
    if (self)
    {
        key = pk;
        sqlite3* database = db;
        
        if (init_statement == nil)
        {
            const char* sql = "SELECT name, recipes FROM ingridients WHERE pk=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK)
            {
                NSAssert(0,@"Error: failed to prepare statment with message '%s'.", sqlite3_errmsg(database));
            }
        }
        
        sqlite3_bind_int (init_statement,1,key);
        if (sqlite3_step(init_statement) == SQLITE_ROW)
        {
            NSString* str=[[NSString alloc]initWithCString:(char*) sqlite3_column_text(init_statement,0) encoding:NSASCIIStringEncoding];
            
            self.name = str;
            [str release];
            
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(init_statement, 1) length:sqlite3_column_bytes(init_statement, 1)];
            
            int size =(int) [data length]/4;
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:size];
            
            
            NSRange r;
            r.length=4;
            r.location=0;
            
            int p;
            for (int i=0;i<size;i++)
            {
                [data getBytes:&p range:r];
                [array addObject:[NSNumber numberWithInt:p]];
                r.location+=r.length;
            }
            [data release];
            
            self.recipes = array;
            [array release];
        }
        
        sqlite3_reset(init_statement);
    }
    return self;
}

-(void) updateDB:(sqlite3 *)db
{
    if (update_statement==nil)
    {
        const char* sql = "UPDATE ingridients SET recipes = ? WHERE pk = ?";
        if (sqlite3_prepare_v2(db, sql, -1, &update_statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare update statement '%s' .", sqlite3_errmsg(db));
        }
    }
    
    sqlite3_bind_int(update_statement, 2, key);
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    for (NSNumber* num in recipes)
    {
        int t = [num intValue];
        [data appendBytes:&t length:4];
    }
    
    sqlite3_bind_blob(update_statement, 1, [data bytes], (int)[data length], SQLITE_TRANSIENT);
    
    int success = sqlite3_step(update_statement);
    
    if (success != SQLITE_DONE)
    {
        NSAssert1(0, @"Error: failed to update '%s' .", sqlite3_errmsg(db));
    }
    
    [data release];
    sqlite3_reset(update_statement);
}

-(void) dealloc
{
    [name release];
    [recipes release];
    
    [super dealloc];
}

@end
