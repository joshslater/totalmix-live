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

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

@synthesize channels;
@synthesize channelsTableView;
@synthesize channelTableCell;
@synthesize detailedChannelViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.channels = [[NSMutableArray alloc]	initWithCapacity:100];
    
    for (int i = 0; i < 20; i++)
    {
        [self.channels addObject: [[Channel alloc] initWithChannelNumber:i]];
    }
    
    // Rotates the view.
    self.channelsTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);  
        
    // Repositions and resizes the view.   
    CGRect contentRect = CGRectMake(0, 0, 768, 1024);  
    self.channelsTableView.frame = contentRect;   
    
    
//    //////////////////////////////////
//    // create detailed channel view //
//    //////////////////////////////////
//    self.detailedChannelViewController = [[DetailedChannelViewController alloc] init];
//    self.detailedChannelViewController.view.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:detailedChannelViewController.view];  
    
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
        
        slider.bounds = CGRectMake(0, 0, 200, 85);
        slider.center = CGPointMake(42.5, 600);
        
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

- (IBAction)eqButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"EQ Button Pushed for Channel %d",indexPath.row);
}

- (IBAction)gateButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"Gate Button Pushed for Channel %d",indexPath.row);
}

- (IBAction)compButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    NSLog(@"Comp Button Pushed for Channel %d",indexPath.row);
}

- (void)channelSliderAction:(UISlider *)sender
{
    // set the volume of the channel
    NSIndexPath *indexPath = [self.channelsTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    Channel *channel = [self.channels objectAtIndex:indexPath.row];
    
    channel.volume = [sender value];
}


@end
