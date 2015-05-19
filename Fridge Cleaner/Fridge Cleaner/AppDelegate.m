//
//  AppDelegate.m
//  Fridge Cleaner
//
//  Created by Owner Owner on 01.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewTab.h"

#import "SecondViewTab.h"
#import "Global.h"

@implementation AppDelegate
@synthesize navController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    
    UINavigationController *viewController1 = [[[UINavigationController alloc] initWithRootViewController:[[[FirstViewTab alloc] initWithNibName:@"FirstViewTab" bundle:nil] autorelease]] autorelease];
    UIViewController *viewController2 = [[[UINavigationController alloc] initWithRootViewController:[[[SecondViewTab alloc] initWithNibName:@"SecondViewTab" bundle:nil] autorelease]]autorelease];
//    UIViewController *viewController1 = [[[FirstViewTab alloc] initWithNibName:@"FirstViewTab" bundle:nil] autorelease];
//    UIViewController *viewController2 = [[[SecondViewTab alloc] initWithNibName:@"SecondViewTab" bundle:nil] autorelease];

    self.tabBarController.viewControllers = @[viewController1, viewController2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    g_data = [[Data alloc] init];
    [g_data loadDatabase];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [g_data reload];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [g_data releaseData];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
