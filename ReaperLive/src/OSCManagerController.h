//
//  OSCManagerController.h
//  ReaperLive
//
//  Created by Josh Slater on 8/28/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <VVOSC/VVOSC.h>
#import "SettingsViewController.h"
#import "TracksViewController.h"
#import "EqViewController.h"

@class TracksViewController;

@interface OSCManagerController : OSCManager <OSCDelegateProtocol, OSCSettingsDelegateProtocol, TracksOscProtocol, EqOscProtocol>
{
    OSCOutPort *oscOutPort;
}

@property (nonatomic, strong) NSMutableArray *tracks;
@property (nonatomic, strong) TracksViewController *tracksViewController;

@end
