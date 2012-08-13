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

@synthesize gainKnobs;
@synthesize freqKnobs;
@synthesize qKnobs;

@synthesize gainLabels;
@synthesize freqLabels;
@synthesize qLabels;

@synthesize gainPoints;
@synthesize freqPoints;


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
    eqPointsView = [[EqPointsView alloc] initWithFrame:CGRectMake(0, 0, 650, 500)];
    eqPointsView.opaque = NO;
    
    // create the EQ curve view
    eqCurveView = [[EqCurveView alloc] initWithFrame:CGRectMake(0, 0, 650, 500)];
    eqCurveView.opaque = NO;
    
    // initialize self's points arrays
    gainPoints = [[NSMutableArray alloc] init];
    freqPoints = [[NSMutableArray alloc] init];        
    
    for (int i = 0; i < 4; i++)
    {
        // initialize the gain points to zero and frequency points to as above
        [gainPoints addObject:[NSNumber numberWithFloat:0.0]];
        [freqPoints addObject:[NSNumber numberWithFloat:(200 + 100*i)]];
    }
    
    // set eqCurveView's points to self's points
    eqCurveView.gainPoints = gainPoints;
    eqCurveView.freqPoints = freqPoints;    
    
    // set eqPointView's points to self's points
    eqPointsView.gainPoints = gainPoints;
    eqPointsView.freqPoints = freqPoints;
    
    int counter = 0;
    
    for (MHRotaryKnob *gainKnob in self.gainKnobs)
    {
        gainKnob.backgroundImage = [UIImage imageNamed:@"Knob-Rim.png"];
        [gainKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateNormal];
        [gainKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateHighlighted];
        [gainKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateDisabled];
        gainKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
        gainKnob.knobImageCenter = CGPointMake(25.0f, 25.0f);
        
        counter++;
    }    
    
    for (MHRotaryKnob *freqKnob in self.freqKnobs)
    {
        freqKnob.backgroundImage = [UIImage imageNamed:@"Knob-Rim.png"];
        [freqKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateNormal];
        [freqKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateHighlighted];
        [freqKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateDisabled];
        freqKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
        freqKnob.knobImageCenter = CGPointMake(25.0f, 25.0f);
        
        
        counter++;
    }     
    
    for (MHRotaryKnob *qKnob in self.qKnobs)
    {
        qKnob.backgroundImage = [UIImage imageNamed:@"Knob-Rim.png"];
        [qKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateNormal];
        [qKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateHighlighted];
        [qKnob setKnobImage:[UIImage imageNamed:@"Knob-Base.png"] forState:UIControlStateDisabled];
        qKnob.interactionStyle = MHRotaryKnobInteractionStyleSliderVertical;
        qKnob.knobImageCenter = CGPointMake(25.0f, 25.0f);
        
        counter++;
    }
        
    [self.view addSubview:eqCurveView];
    [self.view addSubview:eqPointsView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // add targets for each of the knob IBOutletCollections
    for (MHRotaryKnob *gainKnob in gainKnobs)
    {
        [gainKnob addTarget:self action:@selector(gainKnobDidChange:) forControlEvents:UIControlEventValueChanged];
        gainKnob.minimumValue = -20.0;
        gainKnob.maximumValue =  20.0;
        gainKnob.value = 0;
        [self gainKnobDidChange:gainKnob];
    }
    
    // add targets for each of the knob IBOutletCollections
    for (MHRotaryKnob *freqKnob in freqKnobs)
    {
        [freqKnob addTarget:self action:@selector(freqKnobDidChange:) forControlEvents:UIControlEventValueChanged];
        freqKnob.minimumValue = 20.0;
        freqKnob.maximumValue = 22000.0;
        freqKnob.value = 1000;
        [self freqKnobDidChange:freqKnob];
    }
    
    // add targets for each of the knob IBOutletCollections
    for (MHRotaryKnob *qKnob in qKnobs)
    {
        [qKnob addTarget:self action:@selector(qKnobDidChange:) forControlEvents:UIControlEventValueChanged];
        qKnob.minimumValue = 0.1;
        qKnob.maximumValue = 3.0;
        qKnob.value = 0.707;
        [self qKnobDidChange:qKnob];
    }
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
    int idx = [gainKnobs indexOfObject:sender];
    UILabel *gainLabel = [gainLabels objectAtIndex:idx];
    MHRotaryKnob *gainKnob = [gainKnobs objectAtIndex:idx];
    
    // update the label
    gainLabel.text = [NSString stringWithFormat:@"%0.0f",gainKnob.value];
    
    // draw the new EQ curve
    NSNumber *gainPoint = [NSNumber numberWithFloat:gainKnob.value];
    [gainPoints replaceObjectAtIndex:idx withObject:gainPoint];
    
    [self updateEqCurve];
}

- (void)freqKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = [freqKnobs indexOfObject:sender];
    UILabel *freqLabel = [freqLabels objectAtIndex:idx];
    MHRotaryKnob *freqKnob = [freqKnobs objectAtIndex:idx];
    
    // update the label
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",freqKnob.value];
    
    // draw the new EQ curve
    NSNumber *freqPoint = [NSNumber numberWithFloat:freqKnob.value];
    [freqPoints replaceObjectAtIndex:idx withObject:freqPoint];
    
    [self updateEqCurve];
    
}

- (void)qKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = [qKnobs indexOfObject:sender];
    UILabel *qLabel = [qLabels objectAtIndex:idx];
    MHRotaryKnob *qKnob = [qKnobs objectAtIndex:idx];
    
    qLabel.text = [NSString stringWithFormat:@"%0.3f",qKnob.value];
}

- (void)updateEqCurve
{
    // curve
    eqCurveView.gainPoints = gainPoints;
    eqCurveView.freqPoints = freqPoints;
    
    [eqCurveView setNeedsDisplay];
    
    // points
    [eqPointsView updateEqPoints];
}

@end