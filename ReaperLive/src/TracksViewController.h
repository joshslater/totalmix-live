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

@protocol TracksOscProtocol <NSObject>
- (void)volumeFaderDidChange:(int)trackNumber toValue:(float)value;
@end

@interface TracksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailedTrackViewControllerProtocol>
{
    DetailedTrackViewController *detailedTrackViewController;
    NSMutableDictionary *trackCells;
}

@property (weak, nonatomic) id <TracksOscProtocol> oscDelegate;
@property (strong, nonatomic) NSMutableArray *tracks;
@property (strong, nonatomic) UITableView *tracksTableView;
@property (weak, nonatomic) IBOutlet TrackTableCell *trackTableCell;
@property (strong, nonatomic) UIToolbar *tracksToolbar;
// this is a property because the setter is overridden to set the track label's background color
@property (nonatomic) NSInteger selectedTrack;

// button pushes
- (IBAction)eqButtonPressed:(id)sender;
- (IBAction)gateButtonPressed:(id)sender;
- (IBAction)compButtonPressed:(id)sender;
- (void)volumeFaderSliderAction:(UISlider *)sender;

// DetailedTrackViewControllerProtocol implementation
- (void)updateTrackButtons:(NSInteger)trackNumber;
- (void)updateSelectedTrack:(NSInteger)trackNumber;

- (void) updateVolumeFader:(NSNotification *)note;

@end
