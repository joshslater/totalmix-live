//
//  EqThumbView.m
//  ReaperLive
//
//  Created by Josh Slater on 8/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "EqThumbView.h"
#import "Constants.h"
#import "Eq.h"

@implementation EqThumbView

@synthesize eq;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // make it transparent
        [self setOpaque:NO];
        
        // turn off user interaction
        self.userInteractionEnabled = NO;
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    
}


@end
