//
//  AppDelegate.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "AppDelegate.h"

#import "Channel.h"
#import "ChannelsViewController.h"
#import "AuxViewController.h"
#import "SettingsViewController.h"
#import "OSCManagerController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // create channels
    channels = [[NSMutableArray alloc]	initWithCapacity:100];
    
    for (int i = 0; i < 20; i++)
    {
        [channels addObject: [[Channel alloc] initWithChannelNumber:i]];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // main channels mixer
    ChannelsViewController *channelsViewController = [[ChannelsViewController alloc] initWithNibName:@"ChannelsViewController" bundle:nil];
    channelsViewController.channels = channels;
    
    // aux mixer
    AuxViewController *auxViewController = [[AuxViewController alloc] initWithNibName:@"AuxViewController" bundle:nil];
    
    // settings
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    
    
    /**************************/
    /******** OSC STUFF *******/
    /**************************/
    // create an OSCManager- set myself up as its delegate
    oscManagerController = [[OSCManagerController alloc] init];
    settingsViewController.oscSettingsDelegate = oscManagerController;
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:channelsViewController, auxViewController, settingsViewController, nil];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
 
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
