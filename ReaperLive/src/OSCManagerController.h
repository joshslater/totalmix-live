//
//  OSCManagerController.h
//  ReaperLive
//
//  Created by Josh Slater on 8/28/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <VVOSC/VVOSC.h>
#import "SettingsViewController.h"

@interface OSCManagerController : OSCManager <OSCDelegateProtocol, OSCSettingsDelegate>
{
    OSCOutPort *oscOutPort;
}

@end
