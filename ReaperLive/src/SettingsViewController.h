//
//  SettingsViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 8/27/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSCMessagingProtocol.h"
#import "TracksViewController.h"

@class Settings;

@interface SettingsViewController : QuickDialogController <QuickDialogEntryElementDelegate,QuickDialogStyleProvider>
{
    // OSC
    QEntryElement *oscIpAddressElement;
    QEntryElement *oscInPortElement;
    QEntryElement *oscOutPortElement;
    
    // tracks
    QEntryElement *nInputTracksElement;
    QEntryElement *nPlaybackTracksElement;
    QEntryElement *nOutputTracksElement;
}

@property (weak, nonatomic) id <OSCMessagingProtocol> oscSettingsDelegate;
@property (weak, nonatomic) id <TracksViewControllerProtocol> tracksViewControllerDelegate;

@property (strong, nonatomic) Settings *settings;

@end
