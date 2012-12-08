//
//  SettingsViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 8/27/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSCMessagingProtocol.h"

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

@property (strong, nonatomic) Settings *settings;

@end
