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
#import "Constants.h"

@implementation OSCManagerController

@synthesize rowTracks;
@synthesize bankStart;

#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.delegate = self;
    }

    //bankStart = [[NSMutableArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:0], [[NSNumber alloc] initWithInt:0], nil];
    
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
    
#if 0
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
- (void)initState
{
    for(int bus = 0; bus < 3; bus ++)
    {
        switch (bus) {
            case 0:
                [self setBusInput];
                break;
            case 1:
                [self setBusPlayback];
                break;
            case 2:
                [self setBusOutput];
                break;
            default:
                break;
        }
        
        
        
        
    }
}


- (void)sendSetBankStart:(int)bankStartValue
{
    OSCMessage *msg = [OSCMessage createWithAddress:@"/setBankStart"];
    [msg addFloat:(float)bankStartValue];
    
    [oscOutPort sendThisMessage:msg];
    
#if 1
    NSLog(@"OSC TX: /setBankStart %d",bankStartValue);
#endif
}

/*
- (void)setStartTrack:(int)trackNumber page:(int)pageNum
{
    // how many tracks did we move?
    int relativeTrack = trackNumber - [[bankStart objectAtIndex:pageNum-1] intValue];
    
#if 0
    NSLog(@"relativeTrack = %d",relativeTrack);
#endif
    
    oscChangeTrackDirection_t direction;
    if(relativeTrack > 0)
        direction = OSCIncrementTrack;
    else
        direction = OSCDecrementTrack;
    
    for(int i = 0; i < ABS(relativeTrack); i++)
    {
        [self trackPlusMinus:direction page:pageNum];
    }
    
    [bankStart replaceObjectAtIndex:pageNum-1 withObject:[[NSNumber alloc] initWithInt:trackNumber]];
}
 */

// for now, this will only happen on page 1
- (void)volumeFaderDidChange:(int)visibleTrackNumber toValue:(float)value
{
    
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/1/volume%d",visibleTrackNumber]];
    [msg addFloat:value];
    
    [oscOutPort sendThisMessage:msg];
    
#if 1
    NSLog(@"OSC TX: /1/volume%d %0.3f",visibleTrackNumber,value);
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

- (void)eqValueDidChange:(NSInteger)trackNumber band:(NSInteger)band item:(eqItems_t)item value:(float)value
{
    NSString *itemString;
    
    switch (item) {
        case EQItemFrequency:
            itemString = @"eqFreq";
            break;
            
        case EQItemGain:
            itemString = @"eqGain";
            break;
            
        case EQItemQ:
            itemString = @"eqQ";
            break;
            
        default:
            break;
    }
    
    NSString *bandString;
    
    switch (band) {
        case 0:
            bandString = @"1";
            break;
            
        case 1:
            bandString = @"2";
            break;
            
        case 2:
            bandString = @"3";
            break;
            
        default:
            break;
    }
    
    NSString *addressString = [NSString stringWithFormat:@"/2/%@%@",itemString,bandString];
    
    OSCMessage *msg = [OSCMessage createWithAddress:addressString];
    
    // even though the message is specified as "db" for gain, REAPER expects a linear gain value
    float sendValue;
    
    if(item == EQItemGain)
        sendValue = (value + 20)/40;
    else if(item == EQItemQ)
        sendValue = (value - 0.7)/4.3;
    else
        sendValue = (value-1.3)/3;
    
    [msg addFloat:sendValue];
    
#if 1
    NSLog(@"eqValueDidChange::sending %@ %0.2f",addressString,sendValue);
#endif
    
    [oscOutPort sendThisMessage:msg];
}

- (void)setBusInput
{
#if 1
    NSLog(@"oscManagerController::setBusInput");
#endif
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/1/busInput"]];
    [msg addFloat:1.0];
    
    [oscOutPort sendThisMessage:msg];
}

- (void)setBusPlayback
{
#if 1
    NSLog(@"oscManagerController::setBusPlayback");
#endif
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/1/busPlayback"]];
    [msg addFloat:1.0];
    
    [oscOutPort sendThisMessage:msg];
}

- (void)setBusOutput
{
#if 1
    NSLog(@"oscManagerController::setBusOutput");
#endif
    
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/1/busOutput"]];
    [msg addFloat:1.0];
    
    [oscOutPort sendThisMessage:msg];
}

- (void)trackPlusMinus:(oscChangeTrackDirection_t)direction page:(int)pageNum
{
    NSString *directionString;
    
    if(direction == OSCIncrementTrack)
    {
        directionString = @"+";
    }
    else
    {
        directionString = @"-";
    }
    
#if 1
    NSLog(@"/%d/track%@",pageNum,directionString);
#endif
    
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/%d/track%@",pageNum,directionString]];
    [msg addFloat:1.0];
    
    [oscOutPort sendThisMessage:msg];
}

- (void)setPage:(int)pageNum
{
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/%d",pageNum]];
    [msg addFloat:1.0];
    
#if 1
    NSLog(@"/%d",pageNum);
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
        int visibleTrackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        NSString *trackName = [m.value stringValue];
        
#if 0
        NSLog(@"rowTracks[%d].name = %@",trackNumber-1,((Track *)[rowTracks objectAtIndex:trackNumber-1]).name);
        NSLog(@"oscManagerController.rowTracks = %x",(int)rowTracks);
#endif
        
        
#if 1
        NSLog(@"OSC::/1/trackname%d %@",visibleTrackNumber,trackName);
#endif
        
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"visibleTrackNumber", @"trackName", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:visibleTrackNumber], trackName, nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackNameDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    
    ///////// TRACK VOLUME ///////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/1/volume(\\d)$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int visibleTrackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        float trackVolume = [m.value floatValue];
        
#if 1
        NSLog(@"OSC::/1/volume%d %0.3f",visibleTrackNumber,trackVolume);
#endif
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"visibleTrackNumber", @"trackVolume", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:visibleTrackNumber], [NSNumber numberWithFloat:trackVolume], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackVolumeDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    
    /////////// METER LEVEL //////////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/1/level(\\d)Left$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int visibleTrackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        float meterLevel = [m.value floatValue];
        
#if 1
        NSLog(@"OSC::/1/level%dLeft %0.3f",visibleTrackNumber,meterLevel);
#endif
                
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"visibleTrackNumber", @"meterLevel", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:visibleTrackNumber], [NSNumber numberWithFloat:meterLevel], nil];
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
