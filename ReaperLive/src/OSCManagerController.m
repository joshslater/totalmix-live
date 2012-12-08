//
//  OSCManagerController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/28/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "OSCManagerController.h"
#import "Track.h"
#import "Eq.h"

@implementation OSCManagerController

@synthesize rowTracks;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.delegate = self;
    }
        
    return self;
}

#pragma mark -
#pragma mark Private Methods
- (void)setInitialState
{
#if 0
    NSLog(@"oscManagerController::cycleAllTracks");
#endif
    
    OSCMessage *msg;
    
    // page 1
    msg = [OSCMessage createWithAddress:@"/1"];
    [oscOutPort sendThisMessage:msg];

    // start at track 0
    msg = [OSCMessage createWithAddress:@"/setBankStart"];
    [msg addFloat:0.0];
    [oscOutPort sendThisMessage:msg];    
}

#pragma mark -
#pragma mark <OSCSettingsDelegateProtocol>

- (void)updateOscIpAddress:(NSString *)ipAddress inPort:(NSInteger)inPort outPort:(NSInteger)outPort
{
    
#if 1
    NSLog(@"oscManagerController::updateOscIpAddress");
#endif
    
    // create an input port for receiving OSC data
    [self createNewInputForPort:inPort];
    
    // create an output so i can send OSC data to myself
    oscOutPort = [self createNewOutputToAddress:ipAddress atPort:outPort];    
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
#pragma mark <OscMessagingProtocol>
- (void)setBankStart:(int)trackNumber
{
    // update the bankStart private variable
    bankStart = trackNumber;
    
    OSCMessage *msg = [OSCMessage createWithAddress:@"/setBankStart"];
    [msg addFloat:(float)trackNumber];
    
    [oscOutPort sendThisMessage:msg];
    
#if 0
    NSLog(@"OSC TX: /setBankStart %d",trackNumber);
#endif
}


- (void)volumeFaderDidChange:(int)trackNumber toValue:(float)value
{
    int relativeTrackNumber = trackNumber - bankStart;
    
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/1/volume%d",relativeTrackNumber]];
    [msg addFloat:value];
    
    [oscOutPort sendThisMessage:msg];
    
#if 0
    NSLog(@"OSC TX: /1/volume%d %0.3f",relativeTrackNumber,value);
#endif
}

- (void)sendOscAction:(oscActions_t)action
{
    NSInteger actionId;
    
    switch (action) {
        case OSCActionRefreshDevices:
            actionId = 41743;
            break;
            
        default:
            break;
    }

#if 0
    NSLog(@"OSCManagerController :: sending actionId %d",actionId);
#endif
    
    OSCMessage *msg = [OSCMessage createWithAddress:@"/action"];
    [msg addInt:actionId];
    [oscOutPort sendThisMessage:msg];
}

- (void)selectTrack:(NSInteger)trackNumber
{
    OSCMessage *msg = [OSCMessage createWithAddress:@"/device/track/select"];
    [msg addInt:trackNumber];
    [oscOutPort sendThisMessage:msg];
}

- (void)selectFX:(NSInteger)fxNumber
{
    OSCMessage *msg = [OSCMessage createWithAddress:@"/device/fx/select"];
    [msg addInt:fxNumber];
    [oscOutPort sendThisMessage:msg];    
}

- (void)sendCannedMsg
{
    OSCMessage *msg;
    
    msg = [OSCMessage createWithAddress:@"/track/1/fxeq/loshelf/freq/hz"];
    [msg addFloat:200];
    
    [oscOutPort sendThisMessage:msg];   
    
    msg = [OSCMessage createWithAddress:@"/track/1/fxeq/loshelf/gain/db"];
    [msg addFloat:pow(10.0,(10.0/20.0))];
    
    [oscOutPort sendThisMessage:msg];    
}

/*
// initializes all channel and FX states
- (void)sendEntireState
{
    for (Track *track in tracks)
    {
#if 1
        NSLog(@"asdf");
        NSLog(@"Sending track %d state",track.trackNumber);
#endif
        // volume
        NSInteger trackNumber = track.trackNumber;
        [self volumeFaderDidChange:trackNumber toValue:track.volume];
        
        // EQ
        for (NSInteger band = 0; band < 4; band++)
        {
            for(NSInteger eqItem = EQItemGain; eqItem <= EQItemQ; eqItem++)
            {
                if(eqItem == EQItemGain)
                    [self eqValueDidChange:trackNumber band:band item:eqItem value:[[track.eq.gainPoints objectAtIndex:band] floatValue]];
                else if (eqItem == EQItemFrequency)
                    [self eqValueDidChange:trackNumber band:band item:eqItem value:[[track.eq.freqPoints objectAtIndex:band] floatValue]];
                else if (eqItem == EQItemQ)
                    [self eqValueDidChange:trackNumber band:band item:eqItem value:[[track.eq.qPoints objectAtIndex:band] floatValue]];
            }
        }
    }
}
 */

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
    
#if 0
    NSLog(@"eqValueDidChange::sending %@ %0.2f",addressString,sendValue);
#endif
    
    [oscOutPort sendThisMessage:msg];
}

#pragma mark -
#pragma mark <OSCDelegateProtocol> Implementation

- (void)receivedOSCMessage:(OSCMessage *)m
{
#if 0
    NSLog(@"OSC Message Received");
#endif
    
    NSString *address = [m address];
    
#if 0
    NSLog(@"Address = %@, %@",address,[m value]);
#endif
    
    NSRegularExpression *regex;
    NSTextCheckingResult *match;
    
    ///////// TRACK NAME ///////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/1/trackname(\\d)$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int relativeTrackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        int trackNumber = relativeTrackNumber + bankStart;
        
#if 0
        NSLog(@"OSC::/1/trackname%d %@",relativeTrackNumber,[m.value stringValue]);
#endif
        
        NSString *trackName = [m.value stringValue];

        ((Track *)[rowTracks objectAtIndex:trackNumber-1]).name = trackName;
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"trackNumber", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:trackNumber], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackNameDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    
    
    
    ///////// TRACK VOLUME ///////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/1/volume(\\d)$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int relativeTrackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        int trackNumber = relativeTrackNumber + bankStart;
        
#if 0
        NSLog(@"OSC::/1/volume%d %0.3f",relativeTrackNumber,[m.value floatValue]);
#endif
        
        ((Track *)[rowTracks objectAtIndex:trackNumber-1]).volume = [m.value floatValue];
                
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"trackNumber", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:trackNumber], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackVolumeDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    
    /////////// METER LEVEL //////////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/1/level(\\d)Left$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int trackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        
#if 0
        NSLog(@"OSC::/1/level%dLeft %0.3f",trackNumber,[m.value floatValue]);
#endif
        
        ((Track *)[rowTracks objectAtIndex:trackNumber-1]).vuLevel = [m.value floatValue];
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"trackNumber", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:trackNumber], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackVuDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }

}

#pragma mark -
- (void)dealloc
{
    // remove self as observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
