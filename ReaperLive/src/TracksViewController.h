//
//  TracksViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OSCMessagingProtocol.h"
#import "TrackTableCell.h"
#import "DetailedTrackViewController.h"


@protocol TracksViewControllerProtocol <NSObject>

@required
- (void)setNumVisibleTracks:(int)numTracks;
- (void)initializeTracks:(int)numTracks;
- (void)initializeTrackCells:(int)numTracks;
- (void)tracksDidUpdate;

@end


@interface TracksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailedTrackViewControllerProtocol, TracksViewControllerProtocol>
{
    DetailedTrackViewController *detailedTrackViewController;
    NSMutableDictionary *trackCells;
}

@property (weak, nonatomic) id<OSCMessagingProtocol> oscDelegate;
@property (strong, nonatomic) NSMutableArray *tracks;
@property (strong, nonatomic) UITableView *tracksTableView;
@property (weak, nonatomic) IBOutlet TrackTableCell *trackTableCell;
@property (weak, nonatomic) IBOutlet UIToolbar *tracksToolbar;
@property (weak, nonatomic) IBOutlet UIView *masterView;

// number of visible tracks isn't necessarily the number of stored tracks
@property (nonatomic) NSInteger numVisibleTracks;

// buttons to control inputs/playback/outputs
@property (weak, nonatomic) IBOutlet UIButton *inputsButton;
@property (weak, nonatomic) IBOutlet UIButton *playbackButton;
@property (weak, nonatomic) IBOutlet UIButton *outputsButton;

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
