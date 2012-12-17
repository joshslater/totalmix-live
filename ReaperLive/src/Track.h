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

@property int bankStart;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) Eq *eq;

- (id)init;

@end
