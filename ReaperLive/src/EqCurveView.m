//
//  EqCurveView.m
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "EqCurveView.h"

@implementation EqCurveView

@synthesize freqPoints;
@synthesize gainPoints;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        freqPoints = [[NSMutableArray alloc] init];
        gainPoints = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    NSLog(@"In EqCurveView --> drawRect");
    
    UIBezierPath* eqPath = [UIBezierPath bezierPath];
    
    
    // Set the starting point of the shape.
    [eqPath moveToPoint:CGPointMake(0.0, 0.0)];
    
    
    // convert the frequency points into log scale and add line to path
    for (int i = 0; i < 4; i++)
    {
        float logFreq = log10f([[freqPoints objectAtIndex:i] floatValue]) - log10f(20);
        
        if(i == 0)
        {
            NSLog(@"logFreq = %0.3f",logFreq);
        }
        
        // Draw the lines
        [eqPath addLineToPoint:CGPointMake(163 * logFreq, [[gainPoints objectAtIndex:i] floatValue] * -5.1)];
    }
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    [[UIColor redColor] setFill];
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    CGContextTranslateCTM(aRef, 88, 152);
    
    // Adjust the drawing options as needed.
    eqPath.lineWidth = 5;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [eqPath fill];
    [eqPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}


@end
