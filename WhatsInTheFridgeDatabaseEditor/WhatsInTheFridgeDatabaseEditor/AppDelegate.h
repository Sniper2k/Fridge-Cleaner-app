//
//  AppDelegate.h
//  WhatsInTheFridgeDatabaseEditor
//
//  Created by Owner Owner on 11.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <sqlite3.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSButton* addButton;
    IBOutlet NSButton* deleteButton;
    IBOutlet NSButton* saveButton;
    IBOutlet NSButton* addStringButton;
    IBOutlet NSButton* deleteStringButton;
    IBOutlet NSComboBox* recipesCombo;
    IBOutlet NSComboBox* addedCombo;
    IBOutlet NSComboBox* ingridientsCombo;
    IBOutlet NSComboBox* stringsCombo;
    IBOutlet NSTextField* amountsField;
    IBOutlet NSTextField* amountsShowField;
    IBOutlet NSTextField* stringsField;
    sqlite3* dbase;
    NSArray* recipes;
    NSArray* ingridients;
    NSArray* recipesNames;
    NSArray* ingridientsNames;
    NSArray* selectedNames;
    int selected, selectedAdded, selectedString;
}
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSButton* addButton;
@property (nonatomic, retain) IBOutlet NSButton* deleteButton;
@property (nonatomic, retain) IBOutlet NSButton* saveButton;
@property (nonatomic, retain) IBOutlet NSButton* addStringButton;
@property (nonatomic, retain) IBOutlet NSButton* deleteStringButton;
@property (nonatomic, retain) IBOutlet NSComboBox* recipesCombo;
@property (nonatomic, retain) IBOutlet NSComboBox* stringsCombo;
@property (nonatomic, retain) IBOutlet NSComboBox* ingridientsCombo;
@property (nonatomic, retain) IBOutlet NSComboBox* addedCombo;
@property (nonatomic, retain) IBOutlet NSTextField* amountsField;
@property (nonatomic, retain) IBOutlet NSTextField* amountsShowField;
@property (nonatomic, retain) IBOutlet NSTextField* stringsField;
@property (nonatomic, retain) NSArray* recipes;
@property (nonatomic, retain) NSArray* ingridients;
@property (nonatomic, retain) NSArray* selectedNames;
@property (nonatomic, retain) NSArray* recipesNames;
@property (nonatomic, retain) NSArray* ingridientsNames;
@property (assign) int selected,selectedAdded, selectedString;

-(void) loadDataFromDB:(NSURL*) url;
-(IBAction)addPushed:(id)sender;
-(IBAction)deletePushed:(id)sender;
-(IBAction)addStringPushed:(id)sender;
-(IBAction)deleteStringPushed:(id)sender;
-(IBAction)savePushed:(id)sender;
-(IBAction)combo:(id)sender;
-(void) refreshAddedData:(int) sel;
@end
