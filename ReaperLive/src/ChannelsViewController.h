//
//  ChannelsViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ChannelTableCell.h"
#import "DetailedChannelViewController.h"

@interface ChannelsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailedChannelViewControllerProtocol>

@property (strong, nonatomic) NSMutableArray *channels;
@property (strong, nonatomic) IBOutlet UITableView *channelsTableView;
@property (strong, nonatomic) IBOutlet ChannelTableCell *channelTableCell;
@property (strong, nonatomic) IBOutlet UIToolbar *channelsToolbar;
@property (strong, nonatomic) DetailedChannelViewController *detailedChannelViewController;

@property (nonatomic) NSInteger selectedChannel;


// button pushes
- (IBAction)eqButtonPressed:(id)sender;
- (IBAction)gateButtonPressed:(id)sender;
- (IBAction)compButtonPressed:(id)sender;
- (void)channelSliderAction:(UISlider *)sender;

// DetailedChannelViewControllerProtocol implementation
- (void)updateChannelButtons:(NSInteger)channelNumber;

@end
