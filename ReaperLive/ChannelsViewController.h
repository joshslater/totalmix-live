//
//  ChannelsViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChannelTableCell.h"

@interface ChannelsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *channels;
@property (strong, nonatomic) IBOutlet UITableView *channelsTableView;
@property (strong, nonatomic) IBOutlet ChannelTableCell *channelTableCell;
@property (strong, nonatomic) IBOutlet UIToolbar *channelsToolbar;
@property (strong, nonatomic) IBOutlet UIScrollView *detailedChannelScrollView;
@property (strong, nonatomic) UIButton *closeDetailedChannelViewButton;


// button pushes
- (IBAction)eqButtonPressed:(id)sender;
- (IBAction)gateButtonPressed:(id)sender;
- (IBAction)compButtonPressed:(id)sender;
- (void)channelSliderAction:(UISlider *)sender;
- (void)closeDetailedChannelView:(id)sender;



@end
