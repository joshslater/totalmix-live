//
//  Channel.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EqCurve;

@interface Channel : NSObject

@property int channelNumber;
@property float volume;

@property (strong, nonatomic) NSMutableArray *gainPoints;
@property (strong, nonatomic) NSMutableArray *freqPoints;
@property (strong, nonatomic) NSMutableArray *qPoints; 

@property (strong, nonatomic) EqCurve *eqCurve;

- (id)initWithChannelNumber:(int)channelNumber;

@end
