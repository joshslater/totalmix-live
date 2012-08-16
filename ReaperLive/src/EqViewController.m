//
//  EqViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Contants.h"
#import "EqViewController.h"
#import "ChannelsViewController.h"
#import "DetailedChannelViewController.h"
#import "MHRotaryKnob.h"
#import "EqPointsView.h"
#import "EqCurveView.h"

@interface EqViewController ()

@end

@implementation EqViewController


@synthesize eqView;


@synthesize eqCurveView;
@synthesize eqPointsView;

@synthesize gainKnob;
@synthesize freqKnob;
@synthesize qKnob;

@synthesize gainLabel;
@synthesize freqLabel;
@synthesize qLabel;

@synthesize bandSelector;

@synthesize gainPoints;
@synthesize freqPoints;
@synthesize qPoints;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    
    NSLog(@"in eqViewController loadView");
        
    [[NSBundle mainBundle] loadNibNamed:@"EQView" owner:self options:nil];       
    self.view.frame = CGRectMake(2*CHANNELS_WIDTH, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT);
        
    // create the EQ points view
    eqPointsView = [[EqPointsView alloc] initWithFrame:CGRectMake(88, 48, 450, 200)];
    eqPointsView.opaque = NO;
    
    // create the EQ curve view
    eqCurveView = [[EqCurveView alloc] initWithFrame:CGRectMake(88, 48, 450, 200)];
    eqCurveView.opaque = NO;
    
    // initialize self's points arrays
    gainPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:0.0],
                                                            [NSNumber numberWithFloat:0.0],
                                                            [NSNumber numberWithFloat:0.0],
                                                            [NSNumber numberWithFloat:0.0], 
                                                            nil];

    freqPoints = [[NSMutableArray alloc] initWithObjects:   [NSNumber numberWithFloat:30.0],
                                                            [NSNumber numberWithFloat:200.0],
                                                            [NSNumber numberWithFloat:1500.0],
                                                            [NSNumber numberWithFloat:5000.0], 
                                                            nil];
    
    qPoints = [[NSMutableArray alloc] initWithObjects:  [NSNumber numberWithFloat:0.707],
                                                        [NSNumber numberWithFloat:0.707],
                                                        [NSNumber numberWithFloat:0.707],
                                                        [NSNumber numberWithFloat:0.707], 
                                                        nil];
    
    /*
    // initialize a 4-element array with all zeros
    for (int i = 0; i < 4; i++)
    {
        // initialize the gain points to zero and frequency points to as above
        [gainPoints addObject:[NSNumber numberWithFloat:0.0]];
        [freqPoints addObject:[NSNumber numberWithFloat:0.0]];
        [qPoints addObject:[NSNumber numberWithFloat:0.0]];
    }
    */
    
    // set eqCurveView's points to self's points
    eqCurveView.gainPoints = gainPoints;
    eqCurveView.freqPoints = freqPoints;    
    
    // set eqPointView's points to self's points
    eqPointsView.gainPoints = gainPoints;
    eqPointsView.freqPoints = freqPoints;
    
    gainKnob.backgroundImage = [UIImage imageNamed:@"Knob.png"];
    [gainKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateNormal];
    [gainKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateHighlighted];
    [gainKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateDisabled];
    gainKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
    gainKnob.knobImageCenter = CGPointMake(25.0f, 25.0f);
    
    freqKnob.backgroundImage = [UIImage imageNamed:@"Knob.png"];
    [freqKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateNormal];
    [freqKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateHighlighted];
    [freqKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateDisabled];
    freqKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
    freqKnob.knobImageCenter = CGPointMake(25.0f, 25.0f);
    
    qKnob.backgroundImage = [UIImage imageNamed:@"Knob.png"];
    [qKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateNormal];
    [qKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateHighlighted];
    [qKnob setKnobImage:[UIImage imageNamed:@"Knob-Selector.png"] forState:UIControlStateDisabled];
    qKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
    qKnob.knobImageCenter = CGPointMake(25.0f, 25.0f);
    
    [self.view addSubview:eqCurveView];
    [self.view addSubview:eqPointsView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [gainKnob addTarget:self action:@selector(gainKnobDidChange:) forControlEvents:UIControlEventValueChanged];
    gainKnob.minimumValue = DET_EQ_MIN_GAIN;
    gainKnob.maximumValue = DET_EQ_MAX_GAIN;
    // [self gainKnobDidChange:gainKnob];
    
    [freqKnob addTarget:self action:@selector(freqKnobDidChange:) forControlEvents:UIControlEventValueChanged];
    freqKnob.minimumValue = log10f(DET_EQ_MIN_FREQ);
    freqKnob.maximumValue = log10f(DET_EQ_MAX_FREQ);
    // [self freqKnobDidChange:freqKnob];
    
    [qKnob addTarget:self action:@selector(qKnobDidChange:) forControlEvents:UIControlEventValueChanged];
    qKnob.minimumValue = 0.1;
    qKnob.maximumValue = 3.0;
    // [self qKnobDidChange:qKnob];
    
    // add a target for the segmented control
    [bandSelector addTarget:self action:@selector(bandSelectorDidChange:) forControlEvents:UIControlEventValueChanged];
    
    selectedBand = bandSelector.selectedSegmentIndex;
    
    // call the target to initialize it
    [self bandSelectorDidChange:bandSelector];
    
    // update the eq curve
    [self updateEqCurve];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)gainKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = bandSelector.selectedSegmentIndex;
    
#if 0
    NSLog(@"idx = %d",idx);
#endif
    
    // update the label
    gainLabel.text = [NSString stringWithFormat:@"%0.0f",sender.value];
    
    // draw the new EQ curve
    NSNumber *gainPoint = [NSNumber numberWithFloat:sender.value];
    [gainPoints replaceObjectAtIndex:idx withObject:gainPoint];
    
#if 0
    NSLog(@"gainKnobDidChange: gainPoint @ %d = %0.3f",idx,[[gainPoints objectAtIndex:idx] floatValue]);
#endif
    
    [self updateEqCurve];
}

- (void)freqKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = bandSelector.selectedSegmentIndex;

    // update the label
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",pow(10,sender.value)];
    
    // draw the new EQ curve
    NSNumber *freqPoint = [NSNumber numberWithFloat:pow(10,sender.value)];
    [freqPoints replaceObjectAtIndex:idx withObject:freqPoint];
    
#if 0
    NSLog(@"freqKnobDidChange: freqPoint @ %d = %0.3f",idx,[freqPoint floatValue]);
#endif
    
    [self updateEqCurve];
}

- (void)qKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = bandSelector.selectedSegmentIndex;
    
    // update the label
    qLabel.text = [NSString stringWithFormat:@"%0.3f",sender.value];
    
    NSNumber *qPoint = [NSNumber numberWithFloat:sender.value];
    [qPoints replaceObjectAtIndex:idx withObject:qPoint];
    
#if 0
    //NSLog(@"qKnobDidChange: qPoint @ %d = %0.3f",idx,[[qPoints objectAtIndex:idx] floatValue]);
    NSLog(@"qKnobDidChange: qPoint @ %d = %0.3f",idx,sender.value);
#endif    
    
    //[self updateEqCurve];
}

- (void)bandSelectorDidChange:(UISegmentedControl *)sender
{
    int idx = sender.selectedSegmentIndex;
    
#if 0    
    NSLog(@"Selected index: %d",idx);
#endif
    
#if 0
    NSLog(@"bandSelectorDidChange: gainPoint @ %d = %0.3f",idx,[[gainPoints objectAtIndex:idx] floatValue]);
    NSLog(@"bandSelectorDidChange: freqPoint @ %d = %0.3f",idx,[[freqPoints objectAtIndex:idx] floatValue]);
    NSLog(@"bandSelectorDidChange: qPoint @ %d = %0.3f",idx,[[qPoints objectAtIndex:idx] floatValue]);
#endif
    
    // set each rotary knob with the appropraite value
    gainKnob.value = [[gainPoints objectAtIndex:idx] floatValue];
    freqKnob.value = log10f([[freqPoints objectAtIndex:idx] floatValue]);
    qKnob.value = [[qPoints objectAtIndex:idx] floatValue];
    
    // set each label
    gainLabel.text = [NSString stringWithFormat:@"%0.0f",[[gainPoints objectAtIndex:idx] floatValue]];
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",[[freqPoints objectAtIndex:idx] floatValue]];
    qLabel.text = [NSString stringWithFormat:@"%0.3f",[[qPoints objectAtIndex:idx] floatValue]];
}

- (void)updateEqCurve
{
    [eqCurveView setNeedsDisplay];
    
    // points
    [eqPointsView updateEqPoints];
}

@end
