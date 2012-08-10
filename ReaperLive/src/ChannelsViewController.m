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
#import "VolumeSlider.h"
#import "VerticalSlider.h"

#define CHANNELS_HEIGHT 768

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

@synthesize channels;
@synthesize channelsTableView;
@synthesize channelTableCell;
@synthesize channelsToolbar;
@synthesize detailedChannelViewController;

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
    
    /////////////////////////////////////////////
    // create detailed channel view controller //
    /////////////////////////////////////////////
    self.detailedChannelViewController = [[DetailedChannelViewController alloc] init];       
    
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

    [self displayDetailedChannelViewControllerWithOffset:CGPointMake(0, 0)];
    
}

- (IBAction)compButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"Comp Button Pushed for Channel %d",indexPath.row);
    
    [self displayDetailedChannelViewControllerWithOffset:CGPointMake(CHANNELS_WIDTH, 0)];
}

- (IBAction)eqButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"EQ Button Pushed for Channel %d",indexPath.row);
    
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
    [self addChildViewController:detailedChannelViewController];
    [self.view addSubview:detailedChannelViewController.view];
    
    // set content offset to be CHANNELS_WIDTH
    self.detailedChannelViewController.detailedChannelScrollView.contentOffset = offset;
    
    // make sure the close button's alpha is 1
    self.detailedChannelViewController.closeDetailedChannelViewButton.alpha = 1.0;
    
    NSLog(@"scrollview offset = %0.0f",self.detailedChannelViewController.detailedChannelScrollView.contentOffset.x);
}




@end
