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
//    self.detailedChannelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 400)];
//    self.detailedChannelView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:detailedChannelView];  
    
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
    }
    
    // rotate the cell
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);

    
    cell.channelLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
//    [cell.eqButton addTarget:self action:@selector(eqButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
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


@end
