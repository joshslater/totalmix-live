//
//  EqCurveView.m
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "EqCurveView.h"
#import "Constants.h"
#import "Complex.h"
#import "Eq.h"

@implementation EqCurveView

@synthesize eq;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
#if 0
    NSLog(@"In EqCurveView --> drawRect");
    NSLog(@"eqCurve(20) = %0.3f",[[eqCurve objectAtIndex:20] doubleValue]);
#endif
    
    UIBezierPath* eqPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    [eqPath moveToPoint:CGPointMake(0.0, 0.0)];
    
    // convert the frequency points into log scale and add line to path
    for (int i = 0; i <= [eq.nPoints intValue]; i++)
    {
        float logFreq = log10f([[eq.eqFreqPoints objectAtIndex:i] doubleValue]) - log10f(DET_EQ_MIN_FREQ);
        double eqVal = [[eq.eqCurve objectAtIndex:i] doubleValue];
        
#if 0        
        if(i == 0)
        {
            NSLog(@"logFreq = %0.3f",logFreq);
        }
#endif
        
        // Draw the lines
        [eqPath addLineToPoint:CGPointMake(DET_EQ_POINTS_PER_DECADE * logFreq, eqVal * -DET_EQ_POINTS_PER_DB)];
    }
    
    // set the end point
    [eqPath addLineToPoint:CGPointMake(DET_EQ_POINTS_PER_DECADE*(log10f(DET_EQ_MAX_FREQ/DET_EQ_MIN_FREQ)),0.0)];
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    [[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.5] setFill];
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    CGContextTranslateCTM(aRef, 0, (DET_EQ_MAX_GAIN - DET_EQ_MIN_GAIN) * DET_EQ_POINTS_PER_DB / 2);
    
    // Adjust the drawing options as needed.
    eqPath.lineWidth = 3;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [eqPath fill];
    [eqPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}


@end
