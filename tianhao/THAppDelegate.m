//
//  THAppDelegate.m
//  tianhao
//
//  Created by Jonear on 14-6-4.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THAppDelegate.h"
#import "THHomeViewController.h"
#import "THProductViewController.h"
#import "THDiscoverViewController.h"
#import "THMoreViewController.h"

@implementation THAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //vcs
    THHomeViewController *homeViewController = [[THHomeViewController alloc] initWithNibName:@"THHomeViewController" bundle:nil];
    THProductViewController *productViewController = [[THProductViewController alloc] initWithNibName:@"THProductViewController" bundle:nil];
    THDiscoverViewController *disoverViewController = [[THDiscoverViewController alloc] initWithNibName:@"THDiscoverViewController" bundle:nil];
    THMoreViewController *moreViewController = [[THMoreViewController alloc] initWithNibName:@"THMoreViewController" bundle:nil];
    
    //tab
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    [tabbarController.tabBar setBarTintColor:TABBARCOLOR];
    [tabbarController setViewControllers:[NSArray arrayWithObjects:homeViewController, productViewController, disoverViewController, moreViewController, nil]];
    
    //nav
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabbarController];
    [navigationController.navigationBar setBarTintColor:NAVBARCOLOR];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //window
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
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

@end
