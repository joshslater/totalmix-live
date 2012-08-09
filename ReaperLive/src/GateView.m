//
//  GateView.m
//  ReaperLive
//
//  Created by Josh Slater on 7/25/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "GateView.h"

@implementation GateView

@synthesize view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"GateView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
