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

- (void)volumeFaderDidChange:(int)trackNumber toValue:(float)value
{
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/track/%d/volume",trackNumber]];
    [msg addFloat:value];
    
    [oscOutPort sendThisMessage:msg];
    
#if 0
    NSLog(@"Received VolumeFaderDidChange notification, track %d, value %0.3f",trackNumber,value);
#endif
}

- (void)eqValueDidChange:(NSInteger)trackNumber band:(NSInteger)band item:(eqItems_t)item value:(float)value
{
    NSString *itemString;
    
    switch (item) {
        case EQItemFrequency:
            itemString = @"freq/hz";
            break;
            
        case EQItemGain:
            itemString = @"gain/db";
            break;
            
        case EQItemQ:
            itemString = @"q/oct";
            break;
            
        default:
            break;
    }
    
    NSString *bandString;
    
    switch (band) {
        case 0:
            bandString = @"loshelf";
            break;
            
        case 1:
            bandString = @"band/2";
            break;
            
        case 2:
            bandString = @"band/3";
            break;
            
        case 3:
            bandString = @"hishelf";
            break;
            
        default:
            break;
    }
    
    NSString *addressString = [NSString stringWithFormat:@"/track/%d/fxeq/%@/%@",trackNumber,bandString,itemString];
    
    OSCMessage *msg = [OSCMessage createWithAddress:addressString];
    
    // even though the message is specified as "db" for gain, REAPER expects a linear gain value
    float sendValue;
    
    if(item == EQItemGain)
        sendValue = pow(10,value/20);
    else if(item == EQItemQ)
    {
        // need to calculate BW in octaves given Q -- NASTY!
        float q = value;
        /*
        float y = 1 + 1/(2*q*q) + sqrt(((2 + (1/(q*q))) * (2 + (1/(q*q))) - 1) / 4);
        float bwOct = log(y)/log(2);
        */
        
        float Q2bw1st = ((2*q*q)+1)/(2*q*q);
        float Q2bw2nd = pow(2*Q2bw1st,2)/4;
        float Q2bw3rd = sqrt(Q2bw2nd-1);
        float Q2bw4th = Q2bw1st+Q2bw3rd;
        
        float bwOct;
        if(band == 0 | band == 3)
            bwOct = log(Q2bw4th/2)/log(2);
        else
            bwOct = log(Q2bw4th)/log(2);
        
        sendValue = bwOct;
    }
    else
        sendValue = value;
    
    [msg addFloat:sendValue];
    
#if 1
    NSLog(@"eqValueDidChange::sending %@ %0.2f",addressString,sendValue);
#endif
    
    [oscOutPort sendThisMessage:msg];
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
    
    NSRegularExpression *regex;
    NSTextCheckingResult *match;
    
    ///////// TRACK VOLUME ///////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/track/(\\d)/volume$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int trackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        
#if 1
        NSLog(@"OSC::/track/%d/volume %0.3f",trackNumber,[m.value floatValue]);
#endif
    
        ((Track *)[tracks objectAtIndex:trackNumber-1]).volume = [m.value floatValue];
                
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"trackNumber", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:trackNumber], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackVolumeDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    
    /////////// METER LEVEL //////////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/track/(\\d)/vu$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int trackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        
#if 1
        NSLog(@"OSC::/track/%d/vu %0.3f",trackNumber,[m.value floatValue]);
#endif
        
        ((Track *)[tracks objectAtIndex:trackNumber-1]).vuLevel = [m.value floatValue];
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"trackNumber", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:trackNumber], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackVuDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }

}

- (void)dealloc
{
    // remove self as observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
