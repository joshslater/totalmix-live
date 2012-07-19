//
//  ViewController.m
//  ReaperLive Remote
//
//  Created by Josh Slater on 7/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "ViewController.h"
#import "ChannelTableCell.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize channelsTableView;
@synthesize channelsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Chan1",@"Chan2",@"Chan3",@"Chan4",@"Chan5",@"Chan6",@"Chan7",@"Chan8",@"Chan9",@"Chan10",@"Chan11",@"Chan12",@"Chan13",@"Chan14",@"Chan15",@"Chan16",nil];
    
    self.channelsArray = array;
    
    self.channelsTableView.rowHeight = 85.0;
//    self.channelsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;  
    self.channelsTableView.separatorColor = [UIColor blackColor];
    // Rotates the view.   
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI/2);    
    self.channelsTableView.transform = transform;  
    // Repositions and resizes the view.   
    CGRect contentRect = CGRectMake(0, 0, 768, 1000);  
    self.channelsTableView.frame = contentRect;    
    self.channelsTableView.pagingEnabled = YES;   
    
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
    return [channelsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelTableCell *cell = (ChannelTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ChannelTableCell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChannelTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.channelLabel.text = [channelsArray objectAtIndex:indexPath.row];
    
    //tag each button with the row
    cell.gateButton.tag = indexPath.row;
    cell.compButton.tag = indexPath.row;
    cell.eqButton.tag = indexPath.row;  
    
    //assign button pushed events to each button
    [cell.eqButton addTarget:self
                   action:@selector(eqButtonPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    //assign button pushed events to each button
    [cell.compButton addTarget:self
                     action:@selector(compButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    //assign button pushed events to each button
    [cell.gateButton addTarget:self
                     action:@selector(gateButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 85;
//}
//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.transform = transform;
//    cell.backgroundColor = [UIColor blackColor];
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
