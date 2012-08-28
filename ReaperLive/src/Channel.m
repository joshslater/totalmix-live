//
//  Channel.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Channel.h"
#import "Eq.h"

@implementation Channel

@synthesize channelNumber;
@synthesize volume;

@synthesize eq;

- (id)initWithChannelNumber:(int)chanNum
{
    self = [super init];
    
    if(self)
    {
        self.channelNumber = chanNum;

        eq = [[Eq alloc] init];
        
        // initialize self's points arrays
        eq.gainPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:0.0],
                         [NSNumber numberWithFloat:0.0],
                         [NSNumber numberWithFloat:0.0],
                         [NSNumber numberWithFloat:0.0], 
                         nil];
        
        eq.freqPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:30.0],
                         [NSNumber numberWithFloat:200.0],
                         [NSNumber numberWithFloat:1500.0],
                         [NSNumber numberWithFloat:5000.0], 
                         nil];
        
        eq.qPoints = [[NSMutableArray alloc] initWithObjects:  [NSNumber numberWithFloat:0.707],
                      [NSNumber numberWithFloat:0.707],
                      [NSNumber numberWithFloat:0.707],
                      [NSNumber numberWithFloat:0.707], 
                      nil];
        

        
    }
    
    return self;
}

@end
