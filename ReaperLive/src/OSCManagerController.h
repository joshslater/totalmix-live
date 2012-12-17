//
//  OSCManagerController.h
//  ReaperLive
//
//  Created by Josh Slater on 8/28/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <VVOSC/VVOSC.h>
#import "SettingsViewController.h"
#import "OSCMessagingProtocol.h"

@class TracksViewController;

@interface OSCManagerController : OSCManager <OSCDelegateProtocol, OSCMessagingProtocol>
{
    OSCOutPort *oscOutPort;
    
    // current row (0 - 2)
    int currentRow;
    NSMutableDictionary *rowTracks;
}

- (void)setInitialState;

@end
