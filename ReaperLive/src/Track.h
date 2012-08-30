//
//  Track.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Eq;

@interface Track : NSObject

@property int trackNumber;
@property float volume;

@property (strong, nonatomic) Eq *eq;

- (id)initWithTrackNumber:(int)trackNum;

@end
