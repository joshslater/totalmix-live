//
//  DetailedTrackViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 7/29/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "TracksViewController.h"
#import "DetailedTrackViewController.h"
#import "EqViewController.h"
#import "CompView.h"
#import "GateView.h"
#import "MHRotaryKnob.h"
#import "Track.h"

@interface DetailedTrackViewController ()

@end

@implementation DetailedTrackViewController

@synthesize delegate;

@synthesize contentOffset;
@synthesize track;
@synthesize selectedTrack;
 
- (void)loadView
{
#if 0
    NSLog(@"In DetailedTrackViewController -(void)loadView");
#endif
    
    // create an empty view
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, TRACKS_WIDTH, DETAILED_TRACK_VIEW_HEIGHT)];
        
    detailedTrackScrollView = [[UIScrollView alloc] 
                                initWithFrame:CGRectMake(0, 
                                                         0, 
                                                         TRACKS_WIDTH, 
                                                         DETAILED_TRACK_VIEW_HEIGHT)
                               ];
    
    // add the 3 track views
    gateView = [[GateView alloc] initWithFrame:CGRectMake(0, 0, TRACKS_WIDTH, DETAILED_TRACK_VIEW_HEIGHT)];
    [detailedTrackScrollView addSubview:gateView];

    compView = [[CompView alloc] initWithFrame:CGRectMake(TRACKS_WIDTH, 0, TRACKS_WIDTH, DETAILED_TRACK_VIEW_HEIGHT)];
    [detailedTrackScrollView addSubview:compView];
    
    
    /******* EQ VIEW *******/
    
    ///////////////////////////////
    // create eq view controller //
    ///////////////////////////////
#if 0
    NSLog(@"initing eqViewController");
#endif
    
    eqViewController = [[EqViewController alloc] init];
 
    [self addChildViewController:eqViewController];
    [detailedTrackScrollView addSubview:eqViewController.view];
    
    // set the content size to be 3 x 1024
    detailedTrackScrollView.contentSize = CGSizeMake(3*TRACKS_WIDTH, DETAILED_TRACK_VIEW_HEIGHT);
    
    // enable paging
    detailedTrackScrollView.pagingEnabled = YES;
    
    // turn off scroll bar
    detailedTrackScrollView.showsHorizontalScrollIndicator = NO;
    
    // set background color to white
    detailedTrackScrollView.backgroundColor = [UIColor clearColor];
    
    // set the delagate to self
    detailedTrackScrollView.delegate = self;
    
    // add the scrollview to the main view
    [self.view addSubview:detailedTrackScrollView];    
    
    // create the detailed track close button, but don't add to subview yet
    closeDetailedTrackViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeDetailedTrackViewButton.backgroundColor = [UIColor clearColor];
    closeDetailedTrackViewButton.frame = CGRectMake(950, 0, 44, 44);
    [closeDetailedTrackViewButton setImage:[UIImage imageNamed:@"delete_control.jpg"] forState:UIControlStateNormal];
    [closeDetailedTrackViewButton addTarget:self action:@selector(closeDetailedTrackView:) forControlEvents:UIControlEventTouchDown];    
    
    // add the button
    [self.view addSubview:closeDetailedTrackViewButton];
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
    
#if 0
    NSLog(@"In DetailedTrackViewController -(void)viewDidLoad");
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    
#if 0
    NSLog(@"detailedTrackViewController track = %x, contentOffset.x = %0.0f",(unsigned int)self.track,self.contentOffset.x);
#endif   
    
    // need to update the track reference every time the view will appear
    eqViewController.eq = self.track.eq;
    
    // set content offset
    detailedTrackScrollView.contentOffset = self.contentOffset;
}

- (void)viewDidAppear:(BOOL)animated
{
    // make sure the close button is visible
    closeDetailedTrackViewButton.alpha = 1.0;
}

- (void)viewWillDisappear:(BOOL)animated
{
#if 0
    NSLog(@"DetailedTrackViewController:: viewWillDisappear");
#endif
    
    // whenever the detailed track view controller will disappear, need to update the eq buttons for this track
    [delegate updateTrackButtons:self.selectedTrack];
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

- (void)closeDetailedTrackView:(id)sender
{
#if 0
    NSLog(@"Removing scrollview from TracksViewController.m");
#endif
    
    ((TracksViewController *)[self parentViewController]).selectedTrack = -1;
    
    // remove this view controller/view from super
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    [UIView animateWithDuration:0.5
                     animations:^{closeDetailedTrackViewButton.alpha = 0.0;}
                     completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // set the alpha of the close button back to 1
    //closeDetailedTrackViewButton.alpha = 1.0;
    
    [UIView animateWithDuration:0.5
                     animations:^{closeDetailedTrackViewButton.alpha = 1.0;}
                     completion:nil];    
}

@end
