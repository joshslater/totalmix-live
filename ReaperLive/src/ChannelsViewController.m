//
//  ChannelsViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "ChannelsViewController.h"
#import "Channel.h"
#import "ChannelTableCell.h"
#import "VolumeSlider.h"
#import "VerticalSlider.h"
#import "EqViewController.h"
#import "EqThumbView.h"
#import "Eq.h"

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

@synthesize channels;
@synthesize channelsTableView;
@synthesize channelTableCell;
@synthesize channelsToolbar;
@synthesize detailedChannelViewController;

@synthesize selectedChannel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // create UITabBarItem
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Channels" image:nil tag:0];
    }
     
    return self;
}

- (void)viewDidLoad
{
#if 0
    NSLog(@"In EqViewController viewDidLoad, instance %x\n", (unsigned int)self);
#endif
    
    [super viewDidLoad];
    
#if 0
    NSLog(@"channel(0), freqPoint(0) = %0.0f",[[[[channels objectAtIndex:0] freqPoints] objectAtIndex:0] floatValue]);
#endif

    // Rotates the view.
    self.channelsTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);  
      
    // Repositions and resizes the view.
    
    // for some reason the frame's x/y max values are scaled backward -- add the conversion
    // factors to account for it. Not sure why don't have to subtract 49 (tab bar height)
    self.channelsTableView.frame = CGRectMake(0,
                                              channelsToolbar.frame.size.height,
                                              CHANNELS_WIDTH * CHANNELS_HEIGHT/CHANNELS_WIDTH, 
                                              CHANNELS_HEIGHT * CHANNELS_WIDTH/CHANNELS_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height - channelsToolbar.frame.size.height);
    
    /////////////////////////////////////////////
    // create detailed channel view controller //
    /////////////////////////////////////////////
    self.detailedChannelViewController = [[DetailedChannelViewController alloc] init];  
    // set the delegate of the detailedChannelViewController
    detailedChannelViewController.delegate = self;
    
    
    // set the initial channel selection to -1 (no channel selected)
    selectedChannel = -1;
    
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
        
        // give the channel label rounded corners
        cell.channelLabel.layer.cornerRadius = 6;
        //cell.channelLabel.backgroundColor = [UIColor whiteColor];

        /**************************/
        /********* FADER  *********/
        /**************************/
        VolumeSlider *fader = [[VolumeSlider alloc] initWithFrame:CGRectMake(0, 0, 265, 30)];
        [fader setRotatedThumbImage:[UIImage imageNamed:@"FaderCap.png"]];
        [fader setRotatedMinTrackImage:[UIImage imageNamed:@"VolumeSlider.png"]];
        [fader setRotatedMaxTrackImage:[UIImage imageNamed:@"VolumeSlider.png"]];
        
        [fader addTarget:self action:@selector(channelSliderAction:) forControlEvents:UIControlEventValueChanged];
        
        fader.value = 0;
        
        // rotate the slider
        fader.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [cell.contentView addSubview:fader];
        
        fader.bounds = CGRectMake(0, 0, 265, 30);
        fader.center = CGPointMake(70, 515);
        
        cell.volumeSlider = fader;
        
        
        /**************************/
        /********** METER *********/
        /**************************/
        VerticalSlider *meter = [[VerticalSlider alloc] initWithFrame:CGRectMake(0, 0, 225, 30)];
        
        // set the minimum track image
        [meter setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [meter setRotatedMinTrackImage:[UIImage imageNamed:@"Meter.png"]];
        [meter setRotatedMaxTrackImage:[UIImage imageNamed:@"Meter.png"]];
        
        // rotate meter
        meter.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [cell.contentView addSubview:meter];
        
        meter.bounds = CGRectMake(0, 0, 225, 30);
        meter.center = CGPointMake(30, 515);
        
        
        /************************/
        /******** EQ BUTTON *****/
        /************************/
        // add eqThumbView on top of eq button
        cell.eqThumbView = [[EqThumbView alloc] initWithFrame:CGRectMake(0, 0, 83, 83)];
        
        // add the subview
        [cell.eqButton addSubview:cell.eqThumbView];
    }


    // set the slider to 0
    cell.volumeSlider.value = [[self.channels objectAtIndex:indexPath.row] volume];
    
    // rotate the cell
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);

    // populate channel label
    cell.channelLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    // make sure the eqThumbView is plotted correctly
#if 0
    NSLog(@"cellForRowAtIndexPath -- indexPath.row = %d",indexPath.row);
#endif

    // set the eq for each of the eqThumbsView's
    cell.eqThumbView.eq = [[self.channels objectAtIndex:indexPath.row] eq];
    [cell.eqThumbView setNeedsDisplay];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}

- (IBAction)gateButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    self.selectedChannel = indexPath.row;
    
#if 0    
    NSLog(@"Gate Button Pushed for Channel %d",indexPath.row);
#endif

    [self displayDetailedChannelViewControllerWithOffset:CGPointMake(0, 0)];
    
}

- (IBAction)compButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];

    self.selectedChannel = indexPath.row;    
    
#if 0
    NSLog(@"Comp Button Pushed for Channel %d",indexPath.row);
#endif
    
    [self displayDetailedChannelViewControllerWithOffset:CGPointMake(CHANNELS_WIDTH, 0)];
}

- (IBAction)eqButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    self.selectedChannel = indexPath.row;    
    
#if 0
    NSLog(@"EQ Button Pushed for Channel %d",indexPath.row);
#endif
    
    [self displayDetailedChannelViewControllerWithOffset:CGPointMake(2*CHANNELS_WIDTH, 0)];
}

- (void)channelSliderAction:(UISlider *)sender
{
    // set the volume of the channel
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    Channel *channel = [self.channels objectAtIndex:indexPath.row];
    
    channel.volume = [sender value];
    
#if 0    
    NSLog(@"Set Channel %d Volume to %0.3f",indexPath.row,[sender value]);
#endif
}

- (void)displayDetailedChannelViewControllerWithOffset:(CGPoint)offset
{    
#if 0
    NSLog(@"ChannelsViewController: selectedChannel = %d",self.selectedChannel);
    NSLog(@"ChannelsViewController: gainPoint(0) = %0.0f",[[[[[self.channels objectAtIndex:selectedChannel] eq] gainPoints] objectAtIndex:0] floatValue]);
    NSLog(@"gainPoints address = %x",(unsigned int)[[[self.channels objectAtIndex:selectedChannel] eq] gainPoints]);
#endif
    

#if 0
    NSLog(@"setting detailedViewController.channel to %x",(unsigned int)[self.channels objectAtIndex:selectedChannel]);
#endif
    
    // pass the necessary properties about the cahnnel to the detailed view controller
    detailedChannelViewController.channel = [self.channels objectAtIndex:selectedChannel];
    detailedChannelViewController.selectedChannel = self.selectedChannel;
    
    [self addChildViewController:detailedChannelViewController];
    [self.view addSubview:detailedChannelViewController.view];
    
    // set content offset to be CHANNELS_WIDTH
    self.detailedChannelViewController.detailedChannelScrollView.contentOffset = offset;
    
    // make sure the close button's alpha is 1
    self.detailedChannelViewController.closeDetailedChannelViewButton.alpha = 1.0;
    
#if 0
    NSLog(@"scrollview offset = %0.0f",self.detailedChannelViewController.detailedChannelScrollView.contentOffset.x);
#endif
}
     
// override setter for selected channel
- (void)setSelectedChannel:(NSInteger)aSelectedChannel
{
    // set previously selected channel to grey
    ChannelTableCell *cell = (ChannelTableCell *)[self.channelsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedChannel inSection:0]];
    
    cell.channelLabel.backgroundColor = [UIColor lightGrayColor];
    
    selectedChannel = aSelectedChannel;
    
    if(selectedChannel != -1)
    {
        // change the label background of the selected channel
        cell = (ChannelTableCell *)[self.channelsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedChannel inSection:0]];
        
        cell.channelLabel.backgroundColor = [UIColor blackColor];
    }
}

- (void)updateChannelButtons:(NSInteger)channelNumber
{
#if 0
    NSLog(@"ChannelsViewController::updateChannelButtons, channel %d, gainPoints(0) = %0.0f",channelNumber,[[[[[self.channels objectAtIndex:channelNumber] eq] gainPoints] objectAtIndex:0] floatValue]);
#endif
    
    ChannelTableCell *cell = (ChannelTableCell *)[self.channelsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:channelNumber inSection:0]];
    
    [cell.eqThumbView setNeedsDisplay];
}




@end
