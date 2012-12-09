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
- (void)setNTracks:(NSMutableArray *)numTracks;
- (void)refreshTracks;
- (void)refreshTrackCells;
- (void)tracksDidUpdate;

@end


@interface TracksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DetailedTrackViewControllerProtocol, TracksViewControllerProtocol>
{
    DetailedTrackViewController *detailedTrackViewController;
    NSMutableDictionary *trackCells;
    
    // track direction of tracksTableView scrolling
    float startScrollOffset;
    float currentScrollOffset;
}

@property (weak, nonatomic) id<OSCMessagingProtocol> oscDelegate;
@property (strong, nonatomic) NSMutableArray *tracks;
@property (strong, nonatomic) UITableView *tracksTableView;
@property (weak, nonatomic) IBOutlet TrackTableCell *trackTableCell;
@property (weak, nonatomic) IBOutlet UIToolbar *tracksToolbar;
@property (weak, nonatomic) IBOutlet UIView *masterView;

// number of visible tracks isn't necessarily the number of stored tracks
@property (strong, nonatomic) NSMutableArray *nTracks;
// current row
@property (nonatomic) NSInteger currentRow;
// tracks for current row
@property (strong, nonatomic) NSMutableArray *rowTracks;


// buttons to control inputs/playback/outputs
@property (weak, nonatomic) IBOutlet UIButton *setInputButton;
@property (weak, nonatomic) IBOutlet UIButton *setPlaybackButton;
@property (weak, nonatomic) IBOutlet UIButton *setOutputButton;

// buttons to control track +/-
@property (weak, nonatomic) IBOutlet UIButton *trackPlus;
@property (weak, nonatomic) IBOutlet UIButton *trackMinus;

// this is a property because the setter is overridden to set the track label's background color
@property (nonatomic) NSInteger selectedTrack;

// initialization
- (void)initializeTracks;

// button pushes
- (IBAction)eqButtonPressed:(id)sender;
- (IBAction)gateButtonPressed:(id)sender;
- (IBAction)compButtonPressed:(id)sender;
- (void)volumeFaderSliderAction:(UISlider *)sender;
- (IBAction)setInputButtonPressed:(id)sender;
- (IBAction)setPlaybackButtonPressed:(id)sender;
- (IBAction)setOutputButtonPressed:(id)sender;
- (IBAction)trackPlus:(id)sender;
- (IBAction)trackMinus:(id)sender;

// DetailedTrackViewControllerProtocol implementation
- (void)updateTrackButtons:(NSInteger)trackNumber;
- (void)updateSelectedTrack:(NSInteger)trackNumber;
- (void) updateVolumeFader:(NSNotification *)note;

@end
