//
//  Channel.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize channelNumber;

- (id)initWithChannelNumber:(int)channel
{
    self = [super init];
    
    if(self)
    {
        self.channelNumber = channel;
    }
    
    return self;
}

@end
