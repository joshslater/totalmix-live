//
//  Track.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "Track.h"
#import "Eq.h"

@implementation Track

@synthesize trackNumber;
@synthesize name;
@synthesize volume;
@synthesize vuLevel;

@synthesize eq;

- (id)initWithTrackNumber:(int)trackNum
{
#if 0
    NSLog(@"Track::initWithTrackNumber");
#endif
    
    self = [super init];
    
    if(self)
    {
        self.trackNumber = trackNum;

        eq = [[Eq alloc] init];
        
        // initialize self's points arrays
        eq.gainPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:0.0],
                         [NSNumber numberWithFloat:0.0],
                         [NSNumber numberWithFloat:0.0],
                         nil];
        
        eq.freqPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:EQ_LOW_FREQ],
                         [NSNumber numberWithFloat:EQ_MID_FREQ],
                         [NSNumber numberWithFloat:EQ_HIGH_FREQ], 
                         nil];
        
        eq.qPoints = [[NSMutableArray alloc] initWithObjects:  [NSNumber numberWithFloat:1.0],
                      [NSNumber numberWithFloat:1.0],
                      [NSNumber numberWithFloat:1.0],
                      nil];
        

        
    }
    
    return self;
}

@end
