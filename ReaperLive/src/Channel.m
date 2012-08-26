//
//  Channel.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Channel.h"
#import "EqCurve.h"

@implementation Channel

@synthesize channelNumber;
@synthesize volume;

@synthesize gainPoints;
@synthesize freqPoints;
@synthesize qPoints;

@synthesize eqCurve;

- (id)initWithChannelNumber:(int)channel
{
    self = [super init];
    
    if(self)
    {
        self.channelNumber = channel;
        
        // initialize self's points arrays
        gainPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:0.0],
                      [NSNumber numberWithFloat:0.0],
                      [NSNumber numberWithFloat:0.0],
                      [NSNumber numberWithFloat:0.0], 
                      nil];
        
        freqPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:30.0],
                      [NSNumber numberWithFloat:200.0],
                      [NSNumber numberWithFloat:1500.0],
                      [NSNumber numberWithFloat:5000.0], 
                      nil];
        
        qPoints = [[NSMutableArray alloc] initWithObjects:  [NSNumber numberWithFloat:0.707],
                   [NSNumber numberWithFloat:0.707],
                   [NSNumber numberWithFloat:0.707],
                   [NSNumber numberWithFloat:0.707], 
                   nil];
        
        eqCurve = [[EqCurve alloc] init];        
        eqCurve.freqPoints = freqPoints;
        eqCurve.gainPoints = gainPoints;
        eqCurve.qPoints = qPoints;
        
    }
    
    return self;
}

@end
