//
//  EqPointsView.m
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Contants.h"
#import "EqPointsView.h"

@implementation EqPointsView

@synthesize freqPoints;
@synthesize gainPoints;

@synthesize eqPointImages;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gainPoints = [[NSMutableArray alloc] init];
        freqPoints = [[NSMutableArray alloc] init];
        
        
        // add the EQ point markers    
        eqPointImages = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 4; i++)
        {
            UIImageView *eqPoint =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EQ-Point.png"]];
            
#if 0            
            NSLog(@"%x",(unsigned int)eqPoint);
#endif
            
            [eqPointImages addObject:eqPoint]; 
            [self addSubview:eqPoint];
            
            UIImageView *test = [eqPointImages objectAtIndex:i];
            NSLog(@"%x",(unsigned int)test);
        }        
    }
    return self;
}


- (void)updateEqPoints
{
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView *eqPoint = [eqPointImages objectAtIndex:i];
        
        // move the EQ point
        CGRect frame = eqPoint.frame;
        frame.origin.y = (DET_EQ_MAX_GAIN - DET_EQ_MIN_GAIN) * DET_EQ_PIXELS_PER_DB / 2 + [[gainPoints objectAtIndex:i] floatValue] * -DET_EQ_PIXELS_PER_DB;
        frame.origin.x = DET_EQ_PIXELS_PER_DECADE * (log10f([[freqPoints objectAtIndex:i] floatValue]) - log10f(DET_EQ_MIN_FREQ));

        // subtract half the height/width
        frame.origin.x -= frame.size.width/2;
        frame.origin.y -= frame.size.width/2;
        
        eqPoint.frame = frame; 
    }

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
