//
//  EqViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "EqViewController.h"
#import "TracksViewController.h"
#import "DetailedTrackViewController.h"
#import "MHRotaryKnob.h"
#import "EqPointsView.h"
#import "EqCurveView.h"
#import "Eq.h"

@interface EqViewController ()

@end

@implementation EqViewController

@synthesize oscDelegate;

@synthesize eqView;

@synthesize gainKnob;
@synthesize freqKnob;
@synthesize qKnob;

@synthesize gainLabel;
@synthesize freqLabel;
@synthesize qLabel;

@synthesize bandSelector;
@synthesize trackNumber;
@synthesize eq;


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
    self.view.frame = CGRectMake(2*TRACKS_WIDTH, 0, TRACKS_WIDTH, DETAILED_TRACK_VIEW_HEIGHT);
        
    // create the EQ points view
    eqPointsView = [[EqPointsView alloc] initWithFrame:CGRectMake(88, 48, 450, 200)];
    eqPointsView.opaque = NO;
    
    // create the EQ curve view
    eqCurveView = [[EqCurveView alloc] initWithFrame:CGRectMake(88, 48, 450, 200)];
    eqCurveView.opaque = NO;
    
    // reduce height of band selector
    CGRect frame = bandSelector.frame;
    frame.size.height = 34;
    bandSelector.frame = frame;
        
    // change font of band selector
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [bandSelector setTitleTextAttributes:attributes 
                                forState:UIControlStateNormal];

    
#if 0
    NSLog(@"setting eqCurveView's eqCurve reference");
#endif
    
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
    NSLog(@"EqViewController: gainPoint(0) = %0.0f",[[self.track.gainPoints objectAtIndex:0] floatValue]);
#endif    
    
    [gainKnob addTarget:self action:@selector(gainKnobDidChange:) forControlEvents:UIControlEventValueChanged];
    gainKnob.minimumValue = DET_EQ_MIN_GAIN;
    gainKnob.maximumValue = DET_EQ_MAX_GAIN;
    gainKnob.defaultValue = 0.0;
    // [self gainKnobDidChange:gainKnob];
    
    [freqKnob addTarget:self action:@selector(freqKnobDidChange:) forControlEvents:UIControlEventValueChanged];
    freqKnob.minimumValue = log10f(DET_EQ_MIN_FREQ);
    freqKnob.maximumValue = log10f(DET_EQ_MAX_FREQ);
    
    [qKnob addTarget:self action:@selector(qKnobDidChange:) forControlEvents:UIControlEventValueChanged];
    qKnob.minimumValue = 0.2;
    qKnob.maximumValue = 10.0;
    qKnob.defaultValue = 0.707;
    
    // add a target for the segmented control
    [bandSelector addTarget:self action:@selector(bandSelectorDidChange:) forControlEvents:UIControlEventValueChanged];
    
    selectedBand = bandSelector.selectedSegmentIndex;
    
    if(selectedBand == 0 | selectedBand == 3)
        qKnob.maximumValue = 0.707;
    else
        qKnob.maximumValue = 10.0;
     
    // call the target to initialize it
    [self bandSelectorDidChange:bandSelector];
    
    // this calculate's the eqCurve for the track
    [self.eq calculateEqCurve];
    // draws the new curve
    [eqCurveView setNeedsDisplay];
    // updates the location of the points
    [eqPointsView updateEqPoints];
}

- (void)viewWillAppear:(BOOL)animated
{
#if 0
    NSLog(@"in EqViewController viewWillAppear");
    NSLog(@"eqViewController track = %x",(unsigned int)self.track);
    NSLog(@"EqViewController: gainPoint(0) = %0.0f",[[self.track.gainPoints objectAtIndex:0] floatValue]);
#endif

#if 0
    NSLog(@"EqViewController, gainPoints address = %x",(unsigned int)eq.gainPoints);
#endif
    

    eqCurveView.eq = self.eq;
    eqPointsView.eq = self.eq;    
    
    // this calculate's the eqCurve for the track
    [self.eq calculateEqCurve];
    // draws the new curve
    [eqCurveView setNeedsDisplay];
    // updates the location of the points
    [eqPointsView updateEqPoints];
    
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
    [self.eq.gainPoints replaceObjectAtIndex:idx withObject:gainPoint];
    
    [oscDelegate eqValueDidChange:self.trackNumber band:bandSelector.selectedSegmentIndex item:EQItemGain value:sender.value];
    
#if 0
    NSLog(@"gainKnobDidChange: gainPoint @ %d = %0.3f",idx,[[self.track.gainPoints objectAtIndex:idx] floatValue]);
#endif
    
    
#if 0
    NSLog(@"self.track.eqCurve.eqCurve(20) = %0.3f",[[self.track.eqCurve.eqCurve objectAtIndex:20] doubleValue]);
#endif
    
    // this calculate's the eqCurve for the track
    [self.eq calculateEqCurve];
    // draws the new curve
    [eqCurveView setNeedsDisplay];
    // updates the location of the points
    [eqPointsView updateEqPoints];
}

- (void)freqKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = bandSelector.selectedSegmentIndex;

    // update the label
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",pow(10,sender.value)];
    
    // draw the new EQ curve
    NSNumber *freqPoint = [NSNumber numberWithFloat:pow(10,sender.value)];
    [self.eq.freqPoints replaceObjectAtIndex:idx withObject:freqPoint];
    
    [oscDelegate eqValueDidChange:self.trackNumber band:bandSelector.selectedSegmentIndex item:EQItemFrequency value:[freqPoint floatValue]];
    
    
#if 0
    NSLog(@"freqKnobDidChange: freqPoint @ %d = %0.3f",idx,[freqPoint floatValue]);
#endif
 
    // this calculate's the eqCurve for the track
    [self.eq calculateEqCurve];
    // draws the new curve
    [eqCurveView setNeedsDisplay];
    // updates the location of the points
    [eqPointsView updateEqPoints];
}

- (void)qKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = bandSelector.selectedSegmentIndex;
    
    // update the label
    qLabel.text = [NSString stringWithFormat:@"%0.3f",sender.value];
    
    NSNumber *qPoint = [NSNumber numberWithFloat:sender.value];
    [self.eq.qPoints replaceObjectAtIndex:idx withObject:qPoint];
    
    [oscDelegate eqValueDidChange:self.trackNumber band:bandSelector.selectedSegmentIndex item:EQItemQ value:sender.value];
    
#if 0
    //NSLog(@"qKnobDidChange: qPoint @ %d = %0.3f",idx,[[qPoints objectAtIndex:idx] floatValue]);
    NSLog(@"qKnobDidChange: qPoint @ %d = %0.3f",idx,sender.value);
#endif    
    
    // this calculate's the eqCurve for the track
    [self.eq calculateEqCurve];
    // draws the new curve
    [eqCurveView setNeedsDisplay];
    // updates the location of the points
    [eqPointsView updateEqPoints];
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
    gainKnob.value = [[self.eq.gainPoints objectAtIndex:idx] floatValue];
    freqKnob.value = log10f([[self.eq.freqPoints objectAtIndex:idx] floatValue]);
    
    // limit q to 0.707 max value for low and high shelf
    if(idx == 0 | idx == 3)
        qKnob.maximumValue = 0.707;
    else
        qKnob.maximumValue = 10.0;
    
    qKnob.value = [[self.eq.qPoints objectAtIndex:idx] floatValue];
    
    // set each label
    gainLabel.text = [NSString stringWithFormat:@"%0.0f",[[self.eq.gainPoints objectAtIndex:idx] floatValue]];
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",[[self.eq.freqPoints objectAtIndex:idx] floatValue]];
    qLabel.text = [NSString stringWithFormat:@"%0.3f",[[self.eq.qPoints objectAtIndex:idx] floatValue]];
    

    
     
    // set the default value of the frequency knob depending on the band
    switch (idx) {
        case 0:
            freqKnob.defaultValue = log10(EQ_LOW_FREQ);   
            break;
            
        case 1:
            freqKnob.defaultValue = log10(EQ_LOW_MID_FREQ);
            break;
            
        case 2:
            freqKnob.defaultValue = log10(EQ_HIGH_MID_FREQ);
            break;
            
        case 3:
            freqKnob.defaultValue = log10(EQ_HIGH_FREQ);
            break;
            
        default:
            break;
    }
    
    // set the selected band for the current track
    eq.selectedBand = [NSNumber numberWithInt:idx];
}

- (void)dealloc
{   
    // release eqCurveView and eqPointsView
    eqCurveView = nil;
    eqPointsView = nil;
}

@end
