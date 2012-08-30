//
//  TracksViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "TrackTableCell.h"
#import "DetailedTrackViewController.h"

@interface TracksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailedTrackViewControllerProtocol>

@property (strong, nonatomic) NSMutableArray *tracks;
@property (strong, nonatomic) IBOutlet UITableView *tracksTableView;
@property (strong, nonatomic) IBOutlet TrackTableCell *trackTableCell;
@property (strong, nonatomic) IBOutlet UIToolbar *tracksToolbar;
@property (strong, nonatomic) DetailedTrackViewController *detailedTrackViewController;

@property (nonatomic) NSInteger selectedTrack;


// button pushes
- (IBAction)eqButtonPressed:(id)sender;
- (IBAction)gateButtonPressed:(id)sender;
- (IBAction)compButtonPressed:(id)sender;
- (void)trackSliderAction:(UISlider *)sender;

// DetailedTrackViewControllerProtocol implementation
- (void)updateTrackButtons:(NSInteger)trackNumber;

@end
