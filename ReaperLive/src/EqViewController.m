//
//  EqViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "EqViewController.h"
#import "ChannelsViewController.h"
#import "DetailedChannelViewController.h"
#import "MHRotaryKnob.h"
#import "EqPointsView.h"
#import "EqCurveView.h"
#import "Channel.h"
#import "EqCurve.h"

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

@synthesize channel;
@synthesize selectedChannel;


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
    
#if 0
    NSLog(@"in eqViewController loadView");
#endif
        
    [[NSBundle mainBundle] loadNibNamed:@"EQView" owner:self options:nil];       
    self.view.frame = CGRectMake(2*CHANNELS_WIDTH, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT);
        
    // create the EQ points view
    eqPointsView = [[EqPointsView alloc] initWithFrame:CGRectMake(88, 48, 450, 200)];
    eqPointsView.opaque = NO;
    
    // create the EQ curve view
    eqCurveView = [[EqCurveView alloc] initWithFrame:CGRectMake(88, 48, 450, 200)];
    eqCurveView.opaque = NO;
    
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
    
#if 0
    NSLog(@"setting eqCurveView's eqCurve reference");
#endif
    
    // set eqCurveView's points to self's points
    eqCurveView.eqCurve = self.channel.eqCurve.eqCurve;
    eqCurveView.eqFreqPoints = self.channel.eqCurve.eqFreqPoints;    
    
    // set eqPointView's points to self's points
    eqPointsView.gainPoints = self.channel.gainPoints;
    eqPointsView.freqPoints = self.channel.freqPoints;
    
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
#if 0
    NSLog(@"in eqViewController viewDidLoad");
#endif    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
#if 0
    NSLog(@"EqViewController: gainPoint(0) = %0.0f",[[self.channel.gainPoints objectAtIndex:0] floatValue]);
#endif    
    
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

- (void)viewWillAppear:(BOOL)animated
{
#if 0
    NSLog(@"in EqViewController viewWillAppear");
    NSLog(@"eqViewController channel = %x",(unsigned int)self.channel);
    NSLog(@"EqViewController: gainPoint(0) = %0.0f",[[self.channel.gainPoints objectAtIndex:0] floatValue]);
#endif
    
    // need to update the points references every time it will appear
    // set eqCurveView's points to self's points
    eqCurveView.eqCurve = self.channel.eqCurve.eqCurve;
    eqCurveView.eqFreqPoints = self.channel.eqCurve.eqFreqPoints;    
    
    // set eqPointView's points to self's points
    eqPointsView.gainPoints = self.channel.gainPoints;
    eqPointsView.freqPoints = self.channel.freqPoints;
    
    // update the eq curve
    [self updateEqCurve];
    
    // this will initialize all the text fields
    [self bandSelectorDidChange:bandSelector];

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
    [self.channel.gainPoints replaceObjectAtIndex:idx withObject:gainPoint];
    
#if 0
    NSLog(@"gainKnobDidChange: gainPoint @ %d = %0.3f",idx,[[self.channel.gainPoints objectAtIndex:idx] floatValue]);
#endif
    
    
#if 0
    NSLog(@"self.channel.eqCurve.eqCurve(20) = %0.3f",[[self.channel.eqCurve.eqCurve objectAtIndex:20] doubleValue]);
#endif
    
    // FIXME: Why do I have to reset these references?
    eqCurveView.eqCurve = self.channel.eqCurve.eqCurve;
    eqCurveView.eqFreqPoints = self.channel.eqCurve.eqFreqPoints;
    eqCurveView.nPoints = self.channel.eqCurve.nPoints;
    
    [self.channel.eqCurve calculateEqCurve];
    [self updateEqCurve];
    
    // notify ChannelsViewController that it needs to update the button
    [(ChannelsViewController *)self.parentViewController.parentViewController updateSelectedChannelEqButton:selectedChannel];
}

- (void)freqKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = bandSelector.selectedSegmentIndex;

    // update the label
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",pow(10,sender.value)];
    
    // draw the new EQ curve
    NSNumber *freqPoint = [NSNumber numberWithFloat:pow(10,sender.value)];
    [self.channel.freqPoints replaceObjectAtIndex:idx withObject:freqPoint];
    
#if 0
    NSLog(@"freqKnobDidChange: freqPoint @ %d = %0.3f",idx,[freqPoint floatValue]);
#endif

    // FIXME: Why do I have to reset these references?
    eqCurveView.eqCurve = self.channel.eqCurve.eqCurve;
    eqCurveView.eqFreqPoints = self.channel.eqCurve.eqFreqPoints;
    eqCurveView.nPoints = self.channel.eqCurve.nPoints;
    
    [self.channel.eqCurve calculateEqCurve];
    [self updateEqCurve];
    
    // notify ChannelsViewController that it needs to update the button
    [(ChannelsViewController *)self.parentViewController.parentViewController updateSelectedChannelEqButton:selectedChannel];
}

- (void)qKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = bandSelector.selectedSegmentIndex;
    
    // update the label
    qLabel.text = [NSString stringWithFormat:@"%0.3f",sender.value];
    
    NSNumber *qPoint = [NSNumber numberWithFloat:sender.value];
    [self.channel.qPoints replaceObjectAtIndex:idx withObject:qPoint];
    
#if 0
    //NSLog(@"qKnobDidChange: qPoint @ %d = %0.3f",idx,[[qPoints objectAtIndex:idx] floatValue]);
    NSLog(@"qKnobDidChange: qPoint @ %d = %0.3f",idx,sender.value);
#endif    
    
    // FIXME: Why do I have to reset these references?
    eqCurveView.eqCurve = self.channel.eqCurve.eqCurve;
    eqCurveView.eqFreqPoints = self.channel.eqCurve.eqFreqPoints;
    eqCurveView.nPoints = self.channel.eqCurve.nPoints;
    
    // this calculate's the eqCurve for the channel
    [self.channel.eqCurve calculateEqCurve];
    // this plots the new eqCurve
    [self updateEqCurve];
    
    // notify ChannelsViewController that it needs to update the button
    [(ChannelsViewController *)self.parentViewController.parentViewController updateSelectedChannelEqButton:selectedChannel];
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
    gainKnob.value = [[self.channel.gainPoints objectAtIndex:idx] floatValue];
    freqKnob.value = log10f([[self.channel.freqPoints objectAtIndex:idx] floatValue]);
    qKnob.value = [[self.channel.qPoints objectAtIndex:idx] floatValue];
    
    // set each label
    gainLabel.text = [NSString stringWithFormat:@"%0.0f",[[self.channel.gainPoints objectAtIndex:idx] floatValue]];
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",[[self.channel.freqPoints objectAtIndex:idx] floatValue]];
    qLabel.text = [NSString stringWithFormat:@"%0.3f",[[self.channel.qPoints objectAtIndex:idx] floatValue]];
    
    // set the selected band for the current channel
    channel.eqCurve.selectedBand = [NSNumber numberWithInt:idx];
}

- (void)updateEqCurve
{
    [eqCurveView setNeedsDisplay];
    
    // points
    [eqPointsView updateEqPoints];
}

@end
