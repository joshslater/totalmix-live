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
#import "NSMutableArray+Tracks.h"

@implementation OSCManagerController

@synthesize tracks;
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
    // set page 2
    [self setPage:2];
    
    for(int bus = 0; bus < 1; bus ++)
    {
        switch (bus) {
            case 0:
                [self setBusInput:2];
                break;
            case 1:
                [self setBusPlayback:2];
                break;
            case 2:
                [self setBusOutput:2];
                break;
            default:
                break;
        }
        
        for(bankStart = 0; bankStart < 30; bankStart++)
        {
            [[tracks objectAtIndex:bus] setObject:[[Track alloc] init] forKey:[NSNumber numberWithInt:bankStart]];
            [self sendSetBankStart:bankStart];
            
            [NSThread sleepForTimeInterval:0.05];
        }
    }
    
    [tracks removeDuplicateEntries];
    
#if 0
    NSMutableDictionary *myRowTracks = [tracks objectAtIndex:0];
    
    for(id key in myRowTracks)
    {
        NSLog(@"key %d: name = %@",[key intValue], ((Track *)[myRowTracks objectForKey:key]).name);
    }
#endif
    
    // go back to the beginning
    bankStart = 0;
    [self sendSetBankStart:bankStart];
}


- (void)sendSetBankStart:(int)bankStartValue
{
    // set private bankStart variable
    bankStart = bankStartValue;
    
    OSCMessage *msg = [OSCMessage createWithAddress:@"/setBankStart"];
    [msg addFloat:(float)bankStartValue];
    
    [oscOutPort sendThisMessage:msg];
    
#if 1
    NSLog(@"OSC TX: /setBankStart %d",bankStartValue);
#endif
}

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

- (void)setBusInput:(int)pageNum
{
    // update the current row
    currentRow = 0;
    rowTracks = [tracks objectAtIndex:currentRow];
    
#if 1
    NSLog(@"OSC TX: /%d/busInput", pageNum);
#endif
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/%d/busInput",pageNum]];
    [msg addFloat:1.0];
    
    [oscOutPort sendThisMessage:msg];
}

- (void)setBusPlayback:(int)pageNum
{
    // update the current row
    currentRow = 1;
    rowTracks = [tracks objectAtIndex:currentRow];
    
#if 1
    NSLog(@"OSC TX: /%d/busPlayback",pageNum);
#endif
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/%d/busPlayback",pageNum]];
    [msg addFloat:1.0];
    
    [oscOutPort sendThisMessage:msg];
}

- (void)setBusOutput:(int)pageNum
{
    // update the current row
    currentRow = 2;
    rowTracks = [tracks objectAtIndex:currentRow];
    
#if 1
    NSLog(@"OSC TX: /%d/busOutput",pageNum);
#endif
    
    OSCMessage *msg = [OSCMessage createWithAddress:[NSString stringWithFormat:@"/%d/busOutput",pageNum]];
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
    
#if 0
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
    
#if 0
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
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/(\\d)/trackname(\\d{0,1})$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int pageNum = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        int visibleTrackNumber = [[address substringWithRange:[match rangeAtIndex:2]] intValue];
        NSString *trackName = [m.value stringValue];        
        
#if 1
        if(pageNum == 2)
            NSLog(@"OSC RX: /%d/trackname%d %@",pageNum,visibleTrackNumber,trackName);
#endif
        
        // if this is a pageNum 2 update only
        if(pageNum == 2)
        {
            Track *track = [rowTracks objectForKey:[NSNumber numberWithInt:bankStart]];
            track.name = trackName;
            track.bankStart = bankStart;
        }
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"visibleTrackNumber", @"trackName", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:visibleTrackNumber], trackName, nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackParamDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    
    ///////// TRACK VOLUME ///////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/1/volume(\\d)$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int visibleTrackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        float trackVolume = [m.value floatValue];
        
#if 0
        NSLog(@"OSC::/1/volume%d %0.3f",visibleTrackNumber,trackVolume);
#endif
        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"visibleTrackNumber", @"trackVolume", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:visibleTrackNumber], [NSNumber numberWithFloat:trackVolume], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackParamDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }
    
    /////////// METER LEVEL //////////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/1/level(\\d)Left$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        int visibleTrackNumber = [[address substringWithRange:[match rangeAtIndex:1]] intValue];
        float meterLevel = [m.value floatValue];
        
#if 0
        NSLog(@"OSC::/1/level%dLeft %0.3f",visibleTrackNumber,meterLevel);
#endif
                
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"visibleTrackNumber", @"meterLevel", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:visibleTrackNumber], [NSNumber numberWithFloat:meterLevel], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"TrackParamDidChange" object:self userInfo:extraInfo];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
    
    /////////// EQ //////////////
    regex = [NSRegularExpression regularExpressionWithPattern:@"^/2/eq(\\w{1,4})(\\d)$" options:0 error:nil];
    match = [regex firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    
    if (match)
    {
        NSString *param = [address substringWithRange:[match rangeAtIndex:1]];
        int eqBand = [[address substringWithRange:[match rangeAtIndex:2]] intValue];
        float paramVal = [m.value floatValue];
        
#if 0
        NSLog(@"OSC RX: /2/eq%@%d %0.3f",param,eqBand,paramVal);
#endif
                        
        // post notifcation
        NSArray *keys = [[NSArray alloc] initWithObjects:@"bankStart", @"eqParam", @"eqBand", @"value", nil];
        NSArray *objects = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:bankStart], param, [NSNumber numberWithInt:eqBand], [NSNumber numberWithFloat:paramVal], nil];
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        NSNotification *note = [NSNotification notificationWithName:@"DetailedTrackParamDidChange" object:self userInfo:extraInfo];
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
