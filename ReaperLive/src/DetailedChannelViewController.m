//
//  DetailedChannelViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 7/29/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "ChannelsViewController.h"
#import "DetailedChannelViewController.h"
#import "CompView.h"
#import "EQView.h"
#import "GateView.h"
#import "MHRotaryKnob.h"

#define DETAILED_CHANNEL_VIEW_HEIGHT 300

@interface DetailedChannelViewController ()

@end

@implementation DetailedChannelViewController

@synthesize detailedChannelScrollView;
@synthesize closeDetailedChannelViewButton;

- (void)loadView
{
    NSLog(@"In DetailedChannelViewController -(void)loadView");
    
    // create an empty view
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 300)];
        
    self.detailedChannelScrollView = [[UIScrollView alloc] 
                                      initWithFrame:CGRectMake(0, 
                                                               44, 
                                                               CHANNELS_WIDTH, 
                                                               DETAILED_CHANNEL_VIEW_HEIGHT)
                                      ];
    
    // add the 3 channel views
    gateView = [[GateView alloc] initWithFrame:CGRectMake(0, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    [self.detailedChannelScrollView addSubview:gateView];
    
    compView = [[CompView alloc] initWithFrame:CGRectMake(CHANNELS_WIDTH, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    [self.detailedChannelScrollView addSubview:compView];
    
    
    /******* EQ VIEW *******/
    
    eqView = [[EQView alloc] initWithFrame:CGRectMake(2*CHANNELS_WIDTH, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    
    // add targets for each of the knob IBOutletCollections
    for (MHRotaryKnob *gainKnob in eqView.gainKnobs)
    {
        [gainKnob addTarget:self action:@selector(gainKnobDidChange:) forControlEvents:UIControlEventValueChanged];
        gainKnob.minimumValue = -15.0;
        gainKnob.maximumValue =  15.0;
        gainKnob.value = 0;
        [self gainKnobDidChange:gainKnob];
    }
    
    // add targets for each of the knob IBOutletCollections
    for (MHRotaryKnob *freqKnob in eqView.freqKnobs)
    {
        [freqKnob addTarget:self action:@selector(freqKnobDidChange:) forControlEvents:UIControlEventValueChanged];
        freqKnob.minimumValue = 20.0;
        freqKnob.maximumValue = 22000.0;
        freqKnob.value = 1000;
        [self freqKnobDidChange:freqKnob];
    }
    
    // add targets for each of the knob IBOutletCollections
    for (MHRotaryKnob *qKnob in eqView.qKnobs)
    {
        [qKnob addTarget:self action:@selector(qKnobDidChange:) forControlEvents:UIControlEventValueChanged];
        qKnob.minimumValue = 0.1;
        qKnob.maximumValue = 3.0;
        qKnob.value = 0.707;
        [self qKnobDidChange:qKnob];
    }
    
    
    [self.detailedChannelScrollView addSubview:eqView];
    
    // set the content size to be 3 x 1024
    detailedChannelScrollView.contentSize = CGSizeMake(3*CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT);
    
    // enable paging
    detailedChannelScrollView.pagingEnabled = YES;
    
    // turn off scroll bar
    detailedChannelScrollView.showsHorizontalScrollIndicator = NO;
    
    // set background color to white
    detailedChannelScrollView.backgroundColor = [UIColor clearColor];
    
    // set the delagate to self
    detailedChannelScrollView.delegate = self;
    
    // add the scrollview to the main view
    [self.view addSubview:detailedChannelScrollView];    
    
    // create the detailed channel close button, but don't add to subview yet
    closeDetailedChannelViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeDetailedChannelViewButton.backgroundColor = [UIColor clearColor];
    closeDetailedChannelViewButton.frame = CGRectMake(950, 50, 44, 44);
    [closeDetailedChannelViewButton setImage:[UIImage imageNamed:@"delete_control.jpg"] forState:UIControlStateNormal];
    [closeDetailedChannelViewButton addTarget:self action:@selector(closeDetailedChannelView:) forControlEvents:UIControlEventTouchDown];    
    
    // add the button
    [self.view addSubview:closeDetailedChannelViewButton];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"In DetailedChannelViewController -(void)viewDidLoad");
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

- (void)closeDetailedChannelView:(id)sender
{
    NSLog(@"Removing scrollview from ChannelsViewController.m");
        
    // remove this view controller/view from suer
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    // set the alpha of the close button to zero
    //closeDetailedChannelViewButton.alpha = 0.0;
    
    [UIView animateWithDuration:0.5
                     animations:^{closeDetailedChannelViewButton.alpha = 0.0;}
                     completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // set the alpha of the close button back to 1
    //closeDetailedChannelViewButton.alpha = 1.0;
    
    [UIView animateWithDuration:0.5
                     animations:^{closeDetailedChannelViewButton.alpha = 1.0;}
                     completion:nil];    
}

- (void)gainKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = [eqView.gainKnobs indexOfObject:sender];
    UILabel *gainLabel = [eqView.gainLabels objectAtIndex:idx];
    MHRotaryKnob *gainKnob = [eqView.gainKnobs objectAtIndex:idx];
        
    gainLabel.text = [NSString stringWithFormat:@"%0.0f",gainKnob.value];
}

- (void)freqKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = [eqView.freqKnobs indexOfObject:sender];
    UILabel *freqLabel = [eqView.freqLabels objectAtIndex:idx];
    MHRotaryKnob *freqKnob = [eqView.freqKnobs objectAtIndex:idx];
    
    freqLabel.text = [NSString stringWithFormat:@"%0.0f",freqKnob.value];
}

- (void)qKnobDidChange:(MHRotaryKnob *)sender
{
    int idx = [eqView.qKnobs indexOfObject:sender];
    UILabel *qLabel = [eqView.qLabels objectAtIndex:idx];
    MHRotaryKnob *qKnob = [eqView.qKnobs objectAtIndex:idx];
    
    qLabel.text = [NSString stringWithFormat:@"%0.3f",qKnob.value];
}

@end
