//
//  OSCManagerController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/28/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "OSCManagerController.h"
#import "Track.h"
#import "TracksViewController.h"

@implementation OSCManagerController

@synthesize tracks;
@synthesize tracksViewController;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.delegate = self;
    }
    
    // register for volume fader notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOscVolume:) name:@"VolumeFaderDidChange" object:nil];
    
    return self;
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

#pragma mark -
#pragma mark OSC Send Methods

- (void)sendOscVolume:(NSNotification *)note
{
    NSDictionary *extraInfo = [note userInfo];
    int trackNumber = [[extraInfo objectForKey:@"trackNumber"] intValue];
    float value = [[extraInfo objectForKey:@"value"] floatValue];
    
    
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/track/%d/volume",trackNumber]];
    [msg addFloat:value];
    
    [oscOutPort sendThisMessage:msg];
    
#if 0
    NSLog(@"Received VolumeFaderDidChange notification, track %d, value %0.3f",trackNumber,value);
#endif
}

#pragma mark -
#pragma mark OSC Receive Methods


#pragma mark -
#pragma mark <OSCDelegateProtocol> Implementation

- (void)receivedOSCMessage:(OSCMessage *)m
{
#if 0
    NSLog(@"OSC Message Received");
#endif
    
    NSString *address = [m address];

#if 0
    NSLog(@"Address = %@",address);
#endif
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^/track/(\\d)/volume$"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    
    NSTextCheckingResult *match = [regex firstMatchInString:address
                                                    options:0
                                                      range:NSMakeRange(0, [address length])];
    
    

#if 0
    NSLog(@"Num Matches = %d",num);
#endif
    
    if (match)
    {
#if 0       
        NSLog(@"Track Volume Match");
#endif
    
        int trackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        
#if 0
        NSLog(@"OSC message received, trackNumber = %@",[address substringWithRange:[match rangeAtIndex:1]]);
#endif
        
        ((Track *)[tracks objectAtIndex:trackNumber]).volume = [m.value floatValue];
        
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"trackNumber", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:trackNumber], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackVolumeDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
         
        
        //[tracksViewController updateVolumeFader:trackNumber];
        
    }
}

- (void)dealloc
{
    // remove self as observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
