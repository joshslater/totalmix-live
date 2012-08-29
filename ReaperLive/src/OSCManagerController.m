//
//  OSCManagerController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/28/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "OSCManagerController.h"

@implementation OSCManagerController

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.delegate = self;
    }
    
    return self;
}

- (void) receivedOSCMessage:(OSCMessage *)m
{
    NSLog(@"OSC Message Received");
}

- (void)updateOscIpAddress:(NSString *)ipAddress inPort:(NSNumber *)inPort outPort:(NSNumber *)outPort
{
    
#if 0
    NSLog(@"oscManagerController::updateOscIpAddress");
#endif
    
    // create an input port for receiving OSC data
    [self createNewInputForPort:[inPort intValue]];
    
    // create an output so i can send OSC data to myself
    oscOutPort = [self createNewOutputToAddress:ipAddress atPort:[outPort intValue]];    
}

- (void)sendTestOscMsg
{   
    // make an OSC message
    OSCMessage *newMsg = [OSCMessage createWithAddress:@"/Address/Path/1"];
    
    // add a bunch arguments to the message
    [newMsg addInt:12];
    [newMsg addFloat:12.34];
    [newMsg addColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]];
    [newMsg addBOOL:YES];
    [newMsg addString:@"Hello World!"];
    
    // send the OSC message
    [oscOutPort sendThisMessage:newMsg];
}

@end
