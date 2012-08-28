//
//  Channel.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Eq;

@interface Channel : NSObject

@property int channelNumber;
@property float volume;

@property (strong, nonatomic) Eq *eq;

- (id)initWithChannelNumber:(int)chanNum;

@end
