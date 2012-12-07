//
//  EqButton.m
//  ReaperLive
//
//  Created by Josh Slater on 8/31/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "EqButton.h"
#import "Constants.h"
#import "Eq.h"

@implementation EqButton

@synthesize eq;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"initting");
    
    // give the track label rounded corners -- need to do this workaround as just
    // setting the cornerRadius kills scroll performance
    self.backgroundColor = [UIColor clearColor];
    self.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 6;
    self.layer.shouldRasterize = YES;
    self.layer.masksToBounds = NO;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
#if 0
    NSLog(@"EqButton:: drawRect, gainPoint(0): %0.0f",[[eq.gainPoints objectAtIndex:0] floatValue]);
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
        [eqPath addLineToPoint:CGPointMake(EQ_BTN_POINTS_PER_DECADE * logFreq, eqVal * -EQ_BTN_POINTS_PER_DB)];
    }
    
    // set the end point
    [eqPath addLineToPoint:CGPointMake(EQ_BTN_POINTS_PER_DECADE*(log10f(DET_EQ_MAX_FREQ/DET_EQ_MIN_FREQ)),0.0)];
    
    // Set the render colors
    [[UIColor blackColor] setStroke];
    [[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.75] setFill];
    
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    //CGContextTranslateCTM(aRef, 0, (DET_EQ_MAX_GAIN - DET_EQ_MIN_GAIN) * EQ_BTN_POINTS_PER_DB / 2);
    CGContextTranslateCTM(aRef, 0, 41.5);
    
    // Adjust the drawing options as needed.
    eqPath.lineWidth = 1;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [eqPath fill];
    [eqPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef); 
    
}


@end
