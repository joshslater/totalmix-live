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

#define kNTracksKey @"nTracksKey"

#define kNInputTracksKey @"nInputTracksKey"
#define kNPlaybackTracksKey @"nPlaybackTracksKey"
#define kNOutputTracksKey @"nOutputTracksKey"

@interface Settings : NSObject <NSCoding, NSCopying>

// osc
@property (nonatomic, strong) NSString *oscIpAddress;
@property (nonatomic) NSInteger oscInPort;
@property (nonatomic) NSInteger oscOutPort;

// array with number of tracks. idx 0 = input, idx 1 = playback, idx 2 = output
@property (strong, nonatomic) NSMutableArray *nTracks;


@end
