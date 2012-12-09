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

@synthesize nTracks;

#pragma mark -
#pragma mark <NSCoding>

-(id)init
{
    self = [super init];
    if (self)
    {
        self.nTracks = [[NSMutableArray alloc] init];
        
#if 0
        NSLog(@"Creating nTracks");
#endif
        for(int i = 0; i < 3; i++)
        {
            // FIXME: Initting with 0 tracks causes it to crash
            [self.nTracks addObject:[[NSNumber alloc] initWithInt:1]];
        }
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
#if 0
    NSLog(@"settings::initWithCoder");
#endif
    
    self = [super init];
    if (self)
    {
#if 0
        NSLog(@"Decoding Settings");
#endif
        oscIpAddress = [decoder decodeObjectForKey:kIpAddressKey];
        oscInPort = [decoder decodeIntForKey:kInPortKey];
        oscOutPort = [decoder decodeIntForKey:kOutPortKey];
        
        nTracks = (NSMutableArray *)[decoder decodeObjectForKey:kNTracksKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
#if 0
    NSLog(@"Encoding Settings");
#endif
    
    [encoder encodeObject:oscIpAddress forKey:kIpAddressKey];
    [encoder encodeInt:oscInPort forKey:kInPortKey];
    [encoder encodeInt:oscOutPort forKey:kOutPortKey];
    
    [encoder encodeObject:nTracks forKey:kNTracksKey];
}

#pragma mark -
#pragma mark <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    Settings *copy = [[Settings allocWithZone:zone] init];
    
    copy.oscIpAddress = [self.oscIpAddress copyWithZone:zone];
    copy.oscInPort = self.oscInPort;
    copy.oscOutPort = self.oscOutPort;
    
    copy.nTracks = self.nTracks;
    
    return copy;
}

@end
