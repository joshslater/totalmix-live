//
//  Channel.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property int channelNumber;
@property float volume;

- (id)initWithChannelNumber:(int)channelNumber;

@end
