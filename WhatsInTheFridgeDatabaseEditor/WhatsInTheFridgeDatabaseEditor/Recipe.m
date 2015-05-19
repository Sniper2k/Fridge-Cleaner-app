//
//  Recipe.m
//  Fridge Cleaner
//
//  Created by Owner Owner on 10.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "Recipe.h"
static sqlite3_stmt* init_statement=nil;
static sqlite3_stmt* update_statement=nil;

@implementation Recipe
@synthesize ingridients, included, name, smallDescription, strings, amounts;

-(Recipe*) init
{
    self = [super init];
    if (self)
    {
        self.included = 0;
        self.ingridients = [[NSMutableArray alloc] init];
        self.amounts = [[NSMutableArray alloc] init];
        self.strings = [[NSMutableArray alloc] init];
        self.name = [[NSString alloc] init];
        self.smallDescription = [[NSString alloc] init];
    }
    return self;
}

-(Recipe*) initWithPrimaryKey:(int)pk database:(sqlite3 *)db
{
    self = [self init];
    if (self)
    {    
        sqlite3* database = db;
        
        if (init_statement == nil)
        {
            const char* sql = "SELECT name, ingridients, amounts, strings FROM recipes WHERE pk=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK)
            {
                NSAssert(0,@"Error: failed to prepare statment with message '%s'.", sqlite3_errmsg(database));
            }
        }
        
        sqlite3_bind_int (init_statement,1,pk);
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
            self.ingridients = array;
            [array release];
            
            data = [[NSData alloc] initWithBytes:sqlite3_column_blob(init_statement, 2) length:sqlite3_column_bytes(init_statement, 2)];
            
            if ([data length]!=0)
            {
                r.length=4;
                r.location=0;
            
                int numOfAmounts;
                [data getBytes:&numOfAmounts range:r];
                self.amounts = [[NSMutableArray alloc] initWithCapacity:numOfAmounts];
                r.location+=r.length;
                int length;
            
                for (int i=0;i<numOfAmounts;i++)
                {
                    r.length=4;
    
                    [data getBytes:&length range:r];
                
                    r.location+=r.length;
                    r.length=length;
                
                    uint8_t bytes[[data length]];
                    [data getBytes:&bytes range:r];
                    NSString* str = [[NSString alloc] initWithBytes:&bytes length:length encoding: NSASCIIStringEncoding];
                    [amounts addObject:str];
                    [str release];
                    r.location+=length;
                }
            }
            [data release];
            
            data = [[NSData alloc] initWithBytes:sqlite3_column_blob(init_statement, 3) length:sqlite3_column_bytes(init_statement, 3)];
            
            if ([data length]!= 0)
            {
                r.length=4;
                r.location=0;
            
                int length;
                int numOfStrings;
                [data getBytes:&numOfStrings range:r];
                self.strings = [[NSMutableArray alloc] initWithCapacity:numOfStrings];
                r.location+=r.length;
            
                for (int i=0;i<numOfStrings;i++)
                {
                    r.length=4;
                    
                    [data getBytes:&length range:r];
                
                    r.location+=r.length;
                    r.length=length;
                
                    uint8_t bytes[[data length]];
                    [data getBytes:&bytes range:r];
                    NSString* str = [[NSString alloc] initWithBytes:&bytes length:length encoding: NSASCIIStringEncoding];
                    [strings addObject:str];
                    [str release];
                    r.location+=length;
                }
            }
            [data release];
        }
        
        sqlite3_reset(init_statement);
    }
    return self;
}

-(void) updateDB:(sqlite3 *)db Key:(int) key
{
    if (update_statement==nil)
    {
        const char* sql = "UPDATE recipes SET ingridients = ?, amounts = ?, strings = ? WHERE pk = ?";
        if (sqlite3_prepare_v2(db, sql, -1, &update_statement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare update statement '%s' .", sqlite3_errmsg(db));
        }
    }
    
    sqlite3_bind_int(update_statement, 4, key);
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    for (NSNumber* num in ingridients)
    {
        int t = [num intValue];
        [data appendBytes:&t length:4];
    }
    
    sqlite3_bind_blob(update_statement, 1, [data bytes], (int)[data length], SQLITE_TRANSIENT);
    
    NSMutableData* newAmounts = [[NSMutableData alloc] init];
    int size =(int) [amounts count];
    [newAmounts appendBytes:&size length:sizeof(int)];
    for (NSString* amount in amounts)
    {
        NSData* temp = [amount dataUsingEncoding:NSASCIIStringEncoding];
        size = (int) [temp length];
        [newAmounts appendBytes:&size length:sizeof(int)];
        [newAmounts appendData:temp];
    }
    
    sqlite3_bind_blob(update_statement, 2, [newAmounts bytes], (int)[newAmounts length], SQLITE_TRANSIENT);
    
    NSMutableData* newStrings = [[NSMutableData alloc] init];
    size =(int) [strings count];
    [newStrings appendBytes:&size length:sizeof(int)];
    for (NSString* amount in strings)
    {
        NSData* temp = [amount dataUsingEncoding:NSASCIIStringEncoding];
        size = (int) [temp length];
        [newStrings appendBytes:&size length:sizeof(int)];
        [newStrings appendData:temp];
    }
    
    sqlite3_bind_blob(update_statement, 3, [newStrings bytes], (int)[newStrings length], SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(update_statement);
    
    if (success != SQLITE_DONE)
    {
        NSAssert1(0, @"Error: failed to update '%s' .", sqlite3_errmsg(db));
    }
    
    [data release];
    [newAmounts release];
    [newStrings release];
    sqlite3_reset(update_statement);
}

-(void) dealloc
{
    [ingridients release];
    [name release];
    [smallDescription release];
    [strings release];
    [amounts release];
    
    [super dealloc];
}

@end
