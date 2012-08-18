//
//  EqThumbView.m
//  ReaperLive
//
//  Created by Josh Slater on 8/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "EqThumbView.h"
#import "Constants.h"

@implementation EqThumbView

@synthesize gainPoints;
@synthesize freqPoints;
@synthesize qPoints;

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
    // Drawing code
#if 0
    NSLog(@"EqThumbView:: drawRect, gainPoint(0): %0.0f",[[gainPoints objectAtIndex:0] floatValue]);
#endif
    
    UIBezierPath* eqPath = [UIBezierPath bezierPath];
    
    
    // Set the starting point of the shape.
    [eqPath moveToPoint:CGPointMake(0.0, 0.0)];
    
    
    // convert the frequency points into log scale and add line to path
    for (int i = 0; i < 4; i++)
    {
        float logFreq = log10f([[freqPoints objectAtIndex:i] floatValue]) - log10f(DET_EQ_MIN_FREQ);
        
#if 0        
        if(i == 0)
        {
            NSLog(@"logFreq = %0.3f",logFreq);
        }
#endif
        
        // Draw the lines
        [eqPath addLineToPoint:CGPointMake(EQ_BTN_POINTS_PER_DECADE * logFreq, [[gainPoints objectAtIndex:i] floatValue] * -EQ_BTN_POINTS_PER_DB)];
    }
    
    // set the end point
    [eqPath addLineToPoint:CGPointMake(EQ_BTN_POINTS_PER_DECADE*(log10f(DET_EQ_MAX_FREQ/DET_EQ_MIN_FREQ)),0.0)];
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    //[[UIColor redColor] setFill];
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    CGContextTranslateCTM(aRef, 0, (DET_EQ_MAX_GAIN - DET_EQ_MIN_GAIN) * EQ_BTN_POINTS_PER_DB / 2);
    
    // Adjust the drawing options as needed.
    eqPath.lineWidth = 2;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    //[eqPath fill];
    [eqPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}


@end
