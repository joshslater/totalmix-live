//
//  EQView.m
//  ReaperLive
//
//  Created by Josh Slater on 7/25/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "EQView.h"

@implementation EQView

@synthesize view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EQView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

- (IBAction)closeDetailedChannelView:(id)sender
{
    // have to remove the scrollView, which is the EQView's superview
    [self.superview removeFromSuperview];
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
