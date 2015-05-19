//
//  AppDelegate.h
//  Fridge Cleaner
//
//  Created by Owner Owner on 01.05.13.
//  Copyright (c) 2013 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UINavigationController* navController;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) UINavigationController* navController;

@end
