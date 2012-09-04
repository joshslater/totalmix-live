//
//  AppDelegate.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFilename @"archive"
#define kSettingsKey @"settings"

@class ViewController;
@class OSCManagerController;
@class Settings;
@class SettingsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSMutableArray *tracks;
    OSCManagerController *oscManagerController;
    Settings *settings;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
