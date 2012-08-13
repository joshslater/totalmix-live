//
//  EqPointsView.m
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

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
            
            NSLog(@"%x",(unsigned int)eqPoint);
            eqPoint.frame = CGRectMake(200 + 100*i, 150, 15, 15);
            
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
        frame.origin.y = 152 + [[gainPoints objectAtIndex:i] floatValue] * -5.1;
        frame.origin.x = 88 + 163*(log10f([[freqPoints objectAtIndex:i] floatValue]) - log10f(20));
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
