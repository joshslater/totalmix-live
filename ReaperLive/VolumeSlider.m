//
//  VolumeSlider.m
//  ReaperLive
//
//  Created by Josh Slater on 7/29/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "VolumeSlider.h"

@implementation VolumeSlider

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
 
#if 1
    // debug
    CGPoint touchLocation = [touch locationInView:self];
    
    NSLog(@"begin location: (%0.3f, %0.3f)",touchLocation.x,touchLocation.y);
#endif   
    
    // set lastTouch to where the touch was
    lastX = [touch locationInView:self].x;
    
    // want to continue tracking no matter where they touched on the control
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{   
    // NSLog(@"lastX = %0.3f, touch x = %0.3f",lastX,[touch locationInView:self].x);
    
    // take the difference in x-values (since we're rotated) between lastTouch 
    // and touch, and update the slider
    float xDiff = lastX - [touch locationInView:self].x;
    
    // float oldVal = self.value;
    
    // set the slider to be the current value plus the difference, normalized by the
    // slider's height
    self.value = self.value - xDiff/self.frame.size.height;
    
    // send message to registered method for UIControlEventValueChanged
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    // update lastX
    lastX = [touch locationInView:self].x;
    
#if 0
    // debug
    NSLog(@"value = %0.3f, xDiff = %0.3f, newVal = %0.3f, width = %0.3f", oldVal, xDiff, self.value,self.frame.size.height);
#endif
    
    
    // always continue tracking until release
    return YES;    
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
#if 0
    //debug
    CGPoint touchLocation = [touch locationInView:self];
    
    NSLog(@"end location: (%0.3f, %0.3f)",touchLocation.x,touchLocation.y);
#endif
    
    // send message to registered method for UIControlEventValueChanged
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
