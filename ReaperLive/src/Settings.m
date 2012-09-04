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

#pragma mark -
#pragma mark <NSCoding>

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        oscIpAddress = [decoder decodeObjectForKey:kIpAddressKey];
        oscInPort = [decoder decodeIntForKey:kInPortKey];
        oscOutPort = [decoder decodeIntForKey:kOutPortKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:oscIpAddress forKey:kIpAddressKey];
    [encoder encodeInt:oscInPort forKey:kInPortKey];
    [encoder encodeInt:oscOutPort forKey:kOutPortKey];
}

#pragma mark -
#pragma mark <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    Settings *copy = [[Settings allocWithZone:zone] init];
    
    copy.oscIpAddress = [self.oscIpAddress copyWithZone:zone];
    copy.oscInPort = self.oscInPort;
    copy.oscOutPort = self.oscOutPort;
    
    return copy;
}

@end
