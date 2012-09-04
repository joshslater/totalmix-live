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

@interface Settings : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *oscIpAddress;
@property (nonatomic) NSInteger oscInPort;
@property (nonatomic) NSInteger oscOutPort;

@end
