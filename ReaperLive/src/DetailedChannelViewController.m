//
//  DetailedChannelViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 7/29/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "ChannelsViewController.h"
#import "DetailedChannelViewController.h"
#import "EqViewController.h"
#import "CompView.h"
#import "GateView.h"
#import "MHRotaryKnob.h"
#import "Channel.h"

@interface DetailedChannelViewController ()

@end

@implementation DetailedChannelViewController

@synthesize delegate;

@synthesize detailedChannelScrollView;
@synthesize closeDetailedChannelViewButton;

@synthesize eqViewController;

@synthesize channel;
@synthesize selectedChannel;
 
- (void)loadView
{
#if 0
    NSLog(@"In DetailedChannelViewController -(void)loadView");
#endif
    
    // create an empty view
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
        
    self.detailedChannelScrollView = [[UIScrollView alloc] 
                                      initWithFrame:CGRectMake(0, 
                                                               0, 
                                                               CHANNELS_WIDTH, 
                                                               DETAILED_CHANNEL_VIEW_HEIGHT)
                                      ];
    
    // add the 3 channel views
    gateView = [[GateView alloc] initWithFrame:CGRectMake(0, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    [self.detailedChannelScrollView addSubview:gateView];
    
    compView = [[CompView alloc] initWithFrame:CGRectMake(CHANNELS_WIDTH, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    [self.detailedChannelScrollView addSubview:compView];
    
    
    /******* EQ VIEW *******/
    
    ///////////////////////////////
    // create eq view controller //
    ///////////////////////////////
#if 0
    NSLog(@"initing eqViewController");
#endif
    
    self.eqViewController = [[EqViewController alloc] init];
 
    [self addChildViewController:self.eqViewController];
    [self.detailedChannelScrollView addSubview:eqViewController.view];
    
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
    closeDetailedChannelViewButton.frame = CGRectMake(950, 0, 44, 44);
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
    
#if 0
    NSLog(@"In DetailedChannelViewController -(void)viewDidLoad");
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    // need to update the channel reference every time the view will appear
    eqViewController.eq = self.channel.eq;
    
#if 0
    NSLog(@"detailedChannelViewController channel = %x",(unsigned int)self.channel);
#endif   
}

- (void)viewWillDisappear:(BOOL)animated
{
#if 0
    NSLog(@"DetailedChannelViewController:: viewWillDisappear");
#endif
    
    // whenever the detailed channel view controller will disappear, need to update the eq buttons for this channel
    [delegate updateChannelButtons:self.selectedChannel];
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
#if 0
    NSLog(@"Removing scrollview from ChannelsViewController.m");
#endif
    
    ((ChannelsViewController *)[self parentViewController]).selectedChannel = -1;
    
    // remove this view controller/view from super
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

@end
