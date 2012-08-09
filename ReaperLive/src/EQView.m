//
//  EQView.m
//  ReaperLive
//
//  Created by Josh Slater on 7/25/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "EQView.h"
#import "MHRotaryKnob.h"

@implementation EQView

@synthesize view;
@synthesize gainKnobs;
@synthesize freqKnobs;
@synthesize qKnobs;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EQView" owner:self options:nil];
        
        
        int counter = 0;
        
        for (MHRotaryKnob *gainKnob in self.gainKnobs)
        {
            gainKnob.backgroundImage = [UIImage imageNamed:@"Knob Background.png"];
            [gainKnob setKnobImage:[UIImage imageNamed:@"Knob.png"] forState:UIControlStateNormal];
            [gainKnob setKnobImage:[UIImage imageNamed:@"Knob Highlighted.png"] forState:UIControlStateHighlighted];
            [gainKnob setKnobImage:[UIImage imageNamed:@"Knob Disabled.png"] forState:UIControlStateDisabled];
            gainKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
            gainKnob.knobImageCenter = CGPointMake(40.0f, 40.0f);
            
            gainKnob.value = counter*M_PI/50;
            
            counter++;
        }    
        
        for (MHRotaryKnob *freqKnob in self.freqKnobs)
        {
            freqKnob.backgroundImage = [UIImage imageNamed:@"Knob Background.png"];
            [freqKnob setKnobImage:[UIImage imageNamed:@"Knob.png"] forState:UIControlStateNormal];
            [freqKnob setKnobImage:[UIImage imageNamed:@"Knob Highlighted.png"] forState:UIControlStateHighlighted];
            [freqKnob setKnobImage:[UIImage imageNamed:@"Knob Disabled.png"] forState:UIControlStateDisabled];
            freqKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
            freqKnob.knobImageCenter = CGPointMake(40.0f, 40.0f);
            
            freqKnob.value = counter*M_PI/50;
            
            counter++;
        }     
        
        for (MHRotaryKnob *qKnob in self.qKnobs)
        {
            qKnob.backgroundImage = [UIImage imageNamed:@"Knob Background.png"];
            [qKnob setKnobImage:[UIImage imageNamed:@"Knob.png"] forState:UIControlStateNormal];
            [qKnob setKnobImage:[UIImage imageNamed:@"Knob Highlighted.png"] forState:UIControlStateHighlighted];
            [qKnob setKnobImage:[UIImage imageNamed:@"Knob Disabled.png"] forState:UIControlStateDisabled];
            qKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
            qKnob.knobImageCenter = CGPointMake(40.0f, 40.0f);
            
            qKnob.value = counter*M_PI/50;
            
            counter++;
        }

        

        

                
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
;