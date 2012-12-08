//
//  AppDelegate.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"

#import "AppDelegate.h"

#import "OSCMessagingProtocol.h"
#import "Track.h"
#import "TracksViewController.h"
#import "AuxViewController.h"
#import "SettingsViewController.h"
#import "OSCManagerController.h"
#import "Settings.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // create & initialize tracks and cells tracks
    tracks = [[NSMutableArray alloc] init];
    
    // main tracks mixer
    TracksViewController *tracksViewController = [[TracksViewController alloc] initWithNibName:@"TracksViewController" bundle:nil];
    tracksViewController.tracks = tracks;
    
    // aux mixer
    AuxViewController *auxViewController = [[AuxViewController alloc] initWithNibName:@"AuxViewController" bundle:nil];
    
    ////////// SETTINGS ////////////
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settings = [self initializeSettings];
    settingsViewController.settings = settings;
    settingsViewController.tracksViewControllerDelegate = tracksViewController;   

    // initialize tracks based on settings
    tracksViewController.numVisibleTracks = settings.nInputTracks;
    [tracksViewController initializeTracks:settings.nInputTracks];
    [tracksViewController initializeTrackCells:settings.nInputTracks];
    
    NSLog(@"[tracksViewController.tracks count] = %d",[tracksViewController.tracks count]);
        
    /**************************/
    /******** OSC STUFF *******/
    /**************************/
    // create an OSCManager- set myself up as its delegate
    oscManagerController = [[OSCManagerController alloc] init];
    settingsViewController.oscSettingsDelegate = oscManagerController;
    tracksViewController.oscDelegate = oscManagerController;
    // pass the tracks data array to oscManagerController
    oscManagerController.tracks = tracks;
    
    // update the outPort
    [oscManagerController updateOscIpAddress:settings.oscIpAddress inPort:settings.oscInPort outPort:settings.oscOutPort];

    [oscManagerController setInitialState];
    
    
    // refresh the osc device
    //[oscManagerController sendEntireState];
    //[oscManagerController selectFX:1];
    //[oscManagerController selectTrack:1];
    //[oscManagerController sendOscAction:OSCActionRefreshDevices];
    //[oscManagerController sendCannedMsg];
    
    

    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:tracksViewController, auxViewController, settingsViewController, nil];
    
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
    
#if 0    
    NSLog(@"applicationDidEnterBackground");
#endif
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:settings forKey:kSettingsKey];
    [archiver finishEncoding];

#if 0
    NSLog(@"settings.oscIpAddress = %@",settings.oscIpAddress);
    NSLog(@"settings.oscInPort = %d",settings.oscInPort);
#endif
    
    [data writeToFile:[self dataFilePath] atomically:YES];
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

- (Settings *)initializeSettings
{
    Settings *aSettings;
    
    // create the settings object
    if([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]])
    {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        aSettings = [unarchiver decodeObjectForKey:kSettingsKey];
        [unarchiver finishDecoding];
        
#if 0
        NSLog(@"oscIpAddress = %@",aSettings.oscIpAddress);        
#endif
        
    }
    else
    {
        aSettings = [[Settings alloc] init];
    }
    
    return aSettings;
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
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
