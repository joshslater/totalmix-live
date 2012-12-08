//
//  Settings.h
//  ReaperLive
//
//  Created by Josh Slater on 9/3/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIpAddressKey @"ipAddressKey"
#define kOutPortKey @"outPortKey"
#define kInPortKey @"inPortKey"

#define kNInputTracksKey @"nInputTracksKey"
#define kNPlaybackTracksKey @"nPlaybackTracksKey"
#define kNOutputTracksKey @"nOutputTracksKey"


@interface Settings : NSObject <NSCoding, NSCopying>

// osc
@property (nonatomic, strong) NSString *oscIpAddress;
@property (nonatomic) NSInteger oscInPort;
@property (nonatomic) NSInteger oscOutPort;

// number of tracks
@property (nonatomic) NSInteger nInputTracks;
@property (nonatomic) NSInteger nPlaybackTracks;
@property (nonatomic) NSInteger nOutputTracks;


@end
