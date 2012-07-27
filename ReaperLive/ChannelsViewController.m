//
//  ChannelsViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "ChannelsViewController.h"
#import "Channel.h"
#import "ChannelTableCell.h"
#import "CompView.h"
#import "EQView.h"
#import "GateView.h"

#define CHANNELS_WIDTH 1024
#define DETAILED_CHANNEL_VIEW_HEIGHT 300
#define CHANNELS_HEIGHT 768

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

@synthesize channels;
@synthesize channelsTableView;
@synthesize channelTableCell;
@synthesize detailedChannelScrollView;
@synthesize channelsToolbar;
@synthesize closeDetailedChannelViewButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // creat UITabBarItem
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Channels" image:nil tag:0];
    }
     
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"In viewDidLoad, instance %x\n", (unsigned int)self);
    
    [super viewDidLoad];
    
    self.channels = [[NSMutableArray alloc]	initWithCapacity:100];
    
    for (int i = 0; i < 20; i++)
    {
        [self.channels addObject: [[Channel alloc] initWithChannelNumber:i]];
    }

    // Rotates the view.
    self.channelsTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);  
      
    // Repositions and resizes the view.
    
    // for some reason the frame's x/y max values are scaled backward -- add the conversion
    // factors to account for it. Not sure why don't have to subtract 49 (tab bar height)
    self.channelsTableView.frame = CGRectMake(0,
                                              channelsToolbar.frame.size.height,
                                              CHANNELS_WIDTH * CHANNELS_HEIGHT/CHANNELS_WIDTH, 
                                              CHANNELS_HEIGHT * CHANNELS_WIDTH/CHANNELS_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height - channelsToolbar.frame.size.height);
    
    //////////////////////////////////
    // create detailed channel view //
    //////////////////////////////////
    self.detailedChannelScrollView = [[UIScrollView alloc] 
                                      initWithFrame:CGRectMake(0, 
                                                               channelsToolbar.frame.size.height, 
                                                               CHANNELS_WIDTH, 
                                                               DETAILED_CHANNEL_VIEW_HEIGHT)
                                      ];
    
    // add the 3 channel views
    GateView *gateView = [[GateView alloc] initWithFrame:CGRectMake(0, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    [self.detailedChannelScrollView addSubview:gateView];
    
    CompView *compView = [[CompView alloc] initWithFrame:CGRectMake(CHANNELS_WIDTH, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    [self.detailedChannelScrollView addSubview:compView];
    
    EQView *eqView = [[EQView alloc] initWithFrame:CGRectMake(2*CHANNELS_WIDTH, 0, CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT)];
    [self.detailedChannelScrollView addSubview:eqView];
    
    // set the content size to be 3 x 1024
    detailedChannelScrollView.contentSize = CGSizeMake(3*CHANNELS_WIDTH, DETAILED_CHANNEL_VIEW_HEIGHT);
    
    // enable paging
    detailedChannelScrollView.pagingEnabled = YES;
    
    // turn off scroll bar
    detailedChannelScrollView.showsHorizontalScrollIndicator = NO;
    
    // set background color to white
    detailedChannelScrollView.backgroundColor = [UIColor blackColor];
        
    // create the detailed channel close button, but don't add to subview yet
    closeDetailedChannelViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeDetailedChannelViewButton.backgroundColor = [UIColor clearColor];
    closeDetailedChannelViewButton.frame = CGRectMake(950, 50, 44, 44);
    [closeDetailedChannelViewButton setImage:[UIImage imageNamed:@"delete_control.jpg"] forState:UIControlStateNormal];
    [closeDetailedChannelViewButton addTarget:self action:@selector(closeDetailedChannelView:) forControlEvents:UIControlEventTouchDown];
       
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelTableCell *cell = (ChannelTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ChannelTableCell"];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ChannelTableCell" owner:self options:nil];
        cell = [self channelTableCell];
        [self setChannelTableCell:nil];
        
        
        // add fader slider
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 85)];
        [slider addTarget:self action:@selector(channelSliderAction:) forControlEvents:UIControlEventValueChanged];
        
        slider.value = 0;
        
        
        // rotate the slider
        slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [cell.contentView addSubview:slider];
        
        slider.bounds = CGRectMake(0, 0, 300, 85);
        slider.center = CGPointMake(42.5, 450);
        
        cell.volumeSlider = slider;
        
    }


    // set the slider to 0
    cell.volumeSlider.value = [[self.channels objectAtIndex:indexPath.row] volume];

    
    // rotate the cell
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);


    // populate channel label
    cell.channelLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}

- (IBAction)gateButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"Gate Button Pushed for Channel %d",indexPath.row);

    // set content offset to be 0
    detailedChannelScrollView.contentOffset = CGPointMake(0,0);
    
    // display the detailed channel view
    [self.view addSubview:detailedChannelScrollView];  
    
    // display the close button
    [self.view addSubview:closeDetailedChannelViewButton];
}

- (IBAction)compButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"Comp Button Pushed for Channel %d",indexPath.row);
    
    // set content offset to be CHANNELS_WIDTH
    detailedChannelScrollView.contentOffset = CGPointMake(CHANNELS_WIDTH,0);    
    
    // display the detailed channel view
    [self.view addSubview:detailedChannelScrollView];  
    
    // display the close button
    [self.view addSubview:closeDetailedChannelViewButton];
}

- (IBAction)eqButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"EQ Button Pushed for Channel %d",indexPath.row);
    
    // set content offset to be 2*CHANNELS_WIDTH
    detailedChannelScrollView.contentOffset = CGPointMake(2*CHANNELS_WIDTH, 0);
    
    // display the detailed channel view
    [self.view addSubview:detailedChannelScrollView];
    
    // display the close button
    [self.view addSubview:closeDetailedChannelViewButton];
}

- (void)channelSliderAction:(UISlider *)sender
{
    // set the volume of the channel
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    Channel *channel = [self.channels objectAtIndex:indexPath.row];
    
    channel.volume = [sender value];
}

- (void)closeDetailedChannelView:(id)sender
{
    NSLog(@"Removing scrollview from ChannelsViewController.m");
    
    // remove scrollview
    [detailedChannelScrollView removeFromSuperview];
    [closeDetailedChannelViewButton removeFromSuperview];
    
}


@end
