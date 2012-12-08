//
//  Settings.m
//  ReaperLive
//
//  Created by Josh Slater on 9/3/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Settings.h"

@implementation Settings

@synthesize oscIpAddress;
@synthesize oscInPort;
@synthesize oscOutPort;

@synthesize nInputTracks;
@synthesize nPlaybackTracks;
@synthesize nOutputTracks;

#pragma mark -
#pragma mark <NSCoding>

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
#if 1
        NSLog(@"Decoding Settings");
#endif
        oscIpAddress = [decoder decodeObjectForKey:kIpAddressKey];
        oscInPort = [decoder decodeIntForKey:kInPortKey];
        oscOutPort = [decoder decodeIntForKey:kOutPortKey];
        
        nInputTracks = [decoder decodeIntForKey:kNInputTracksKey];
        nPlaybackTracks = [decoder decodeIntForKey:kNPlaybackTracksKey];
        nOutputTracks = [decoder decodeIntForKey:kNOutputTracksKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
#if 1
    NSLog(@"Encoding Settings");
#endif
    
    [encoder encodeObject:oscIpAddress forKey:kIpAddressKey];
    [encoder encodeInt:oscInPort forKey:kInPortKey];
    [encoder encodeInt:oscOutPort forKey:kOutPortKey];
    
    [encoder encodeInt:nInputTracks forKey:kNInputTracksKey];
    [encoder encodeInt:nPlaybackTracks forKey:kNPlaybackTracksKey];
    [encoder encodeInt:nOutputTracks forKey:kNOutputTracksKey];
}

#pragma mark -
#pragma mark <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    Settings *copy = [[Settings allocWithZone:zone] init];
    
    copy.oscIpAddress = [self.oscIpAddress copyWithZone:zone];
    copy.oscInPort = self.oscInPort;
    copy.oscOutPort = self.oscOutPort;
    
    copy.nInputTracks = self.nInputTracks;
    copy.nPlaybackTracks = self.nPlaybackTracks;
    copy.nOutputTracks = self.nOutputTracks;
    
    return copy;
}

@end
