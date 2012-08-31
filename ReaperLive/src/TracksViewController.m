//
//  TracksViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "TracksViewController.h"
#import "Track.h"
#import "TrackTableCell.h"
#import "VolumeSlider.h"
#import "VerticalSlider.h"
#import "EqViewController.h"
#import "EqThumbView.h"
#import "Eq.h"

@interface TracksViewController ()

@end

@implementation TracksViewController

#pragma mark Properties

@synthesize tracks;
@synthesize tracksTableView;
@synthesize trackTableCell;
@synthesize tracksToolbar;
@synthesize selectedTrack;

// override setter for selected track
- (void)setSelectedTrack:(NSInteger)aSelectedTrack
{
    // set previously selected track to grey
    TrackTableCell *cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedTrack inSection:0]];
    
    cell.trackLabel.backgroundColor = [UIColor lightGrayColor];
    
    selectedTrack = aSelectedTrack;
    
    if(selectedTrack != -1)
    {
        // change the label background of the selected track
        cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedTrack inSection:0]];
        
        cell.trackLabel.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // create UITabBarItem
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Tracks" image:nil tag:0];
    }
     
    // register for track volume updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVolumeFader:) name:@"TrackVolumeDidChange" object:nil];
    
    volumeSliders = nil;
    
    return self;
}

- (void)viewDidLoad
{
#if 0
    NSLog(@"In EqViewController viewDidLoad, instance %x\n", (unsigned int)self);
#endif
    
    [super viewDidLoad];
    
#if 0
    NSLog(@"track(0), freqPoint(0) = %0.0f",[[[[tracks objectAtIndex:0] freqPoints] objectAtIndex:0] floatValue]);
#endif

    
    // Rotates the view.
    self.tracksTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);  
      
    // Repositions and resizes the view.
    
    // for some reason the frame's x/y max values are scaled backward -- add the conversion
    // factors to account for it. Not sure why don't have to subtract 49 (tab bar height)
    self.tracksTableView.frame = CGRectMake(0,
                                            tracksToolbar.frame.size.height,
                                            TRACKS_WIDTH * TRACKS_HEIGHT/TRACKS_WIDTH, 
                                            TRACKS_HEIGHT * TRACKS_WIDTH/TRACKS_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height - tracksToolbar.frame.size.height);
    
    /////////////////////////////////////////////
    // create detailed track view controller //
    /////////////////////////////////////////////
    detailedTrackViewController = [[DetailedTrackViewController alloc] init];  
    // set the delegate of the detailedTrackViewController
    detailedTrackViewController.delegate = self;
    
    
    // set the initial track selection to -1 (no track selected)
    self.selectedTrack = -1;
    
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
    return [self.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackTableCell *cell = (TrackTableCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackTableCell"];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TrackTableCell" owner:self options:nil];
        cell = [self trackTableCell];
        //[self setTrackTableCell:nil];
        
        // give the track label rounded corners
        cell.trackLabel.layer.cornerRadius = 6;
        //cell.trackLabel.backgroundColor = [UIColor whiteColor];

        /**************************/
        /********* FADER  *********/
        /**************************/
        VolumeSlider *fader = [[VolumeSlider alloc] initWithFrame:CGRectMake(0, 0, 265, 30)];
        [fader setRotatedThumbImage:[UIImage imageNamed:@"FaderCap.png"]];
        [fader setRotatedMinTrackImage:[UIImage imageNamed:@"VolumeSlider.png"]];
        [fader setRotatedMaxTrackImage:[UIImage imageNamed:@"VolumeSlider.png"]];
        
        [fader addTarget:self action:@selector(volumeFaderSliderAction:) forControlEvents:UIControlEventValueChanged];
        
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
        
        
        /************************/
        /******** EQ BUTTON *****/
        /************************/
        // add eqThumbView on top of eq button
        cell.eqThumbView = [[EqThumbView alloc] initWithFrame:CGRectMake(0, 0, 83, 83)];
        
        // add the subview
        [cell.eqButton addSubview:cell.eqThumbView];
    }
    
    if(![volumeSliders objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]])
    {
        [volumeSliders setValue:cell.volumeSlider forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }

    // set the slider to 0
    cell.volumeSlider.value = [[self.tracks objectAtIndex:indexPath.row] volume];
    
    // rotate the cell
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);

    // populate track label
    cell.trackLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    // set it black if it's selected, otherwise grey
    if(indexPath.row == selectedTrack)
    {
        cell.trackLabel.backgroundColor = [UIColor blackColor];
    }
    else 
    {
        cell.trackLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    // make sure the eqThumbView is plotted correctly
#if 0
    NSLog(@"cellForRowAtIndexPath -- indexPath.row = %d, cell = 0x%x, vol = %0.3f",indexPath.row,(unsigned int)cell,[[self.tracks objectAtIndex:indexPath.row] volume]);
#endif

    // set the eq for each of the eqThumbsView's
    cell.eqThumbView.eq = [[self.tracks objectAtIndex:indexPath.row] eq];
    [cell.eqThumbView setNeedsDisplay];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}

#pragma mark -
#pragma mark Action Handling

- (IBAction)gateButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    self.selectedTrack = indexPath.row;
    
#if 0    
    NSLog(@"Gate Button Pushed for Track %d",indexPath.row);
#endif

    [self displayDetailedTrackViewControllerWithOffset:CGPointMake(0, 0)];
    
}

- (IBAction)compButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];

    self.selectedTrack = indexPath.row;    
    
#if 0
    NSLog(@"Comp Button Pushed for Track %d",indexPath.row);
#endif
    
    [self displayDetailedTrackViewControllerWithOffset:CGPointMake(TRACKS_WIDTH, 0)];
}

- (IBAction)eqButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    self.selectedTrack = indexPath.row;    
    
#if 0
    NSLog(@"EQ Button Pushed for Track %d",indexPath.row);
#endif
    
    [self displayDetailedTrackViewControllerWithOffset:CGPointMake(2*TRACKS_WIDTH, 0)];
}

- (void)volumeFaderSliderAction:(UISlider *)sender
{
    // set the volume of the track
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    Track *track = [self.tracks objectAtIndex:indexPath.row];
    NSNumber *trackNumber = [NSNumber numberWithInt:indexPath.row];
    
    track.volume = [sender value];
    
    // post a notification
    NSArray *keys = [[NSArray alloc] initWithObjects:@"trackNumber", @"value", nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:trackNumber, [NSNumber numberWithFloat:sender.value], nil];
    NSDictionary *extraInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSNotification *note = [NSNotification notificationWithName:@"VolumeFaderDidChange" object:self userInfo:extraInfo];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
#if 0    
    NSLog(@"Set Track %d Volume to %0.3f",indexPath.row,[sender value]);
#endif
}

#pragma mark -
#pragma mark View Handling

- (void)displayDetailedTrackViewControllerWithOffset:(CGPoint)offset
{    
#if 0
    NSLog(@"TracksViewController: selectedTrack = %d",selectedTrack);
    NSLog(@"TracksViewController: gainPoint(0) = %0.0f",[[[[[self.tracks objectAtIndex:selectedTrack] eq] gainPoints] objectAtIndex:0] floatValue]);
    NSLog(@"gainPoints address = %x",(unsigned int)[[[self.tracks objectAtIndex:selectedTrack] eq] gainPoints]);
#endif
    

#if 0
    NSLog(@"setting detailedViewController.track to %x",(unsigned int)[self.tracks objectAtIndex:selectedTrack]);
#endif
    
    // pass the necessary properties about the cahnnel to the detailed view controller
    detailedTrackViewController.track = [self.tracks objectAtIndex:selectedTrack];
    detailedTrackViewController.selectedTrack = selectedTrack;
        
    // set content offset to be TRACKS_WIDTH
    detailedTrackViewController.contentOffset = offset;
    
    [self addChildViewController:detailedTrackViewController];
    [self.view addSubview:detailedTrackViewController.view];
    
#if 0
    NSLog(@"scrollview offset = %0.0f",offset.x);
#endif
}

#pragma mark -
#pragma mark DetailedTrackViewControllerDelegate Implementation

- (void)updateTrackButtons:(NSInteger)trackNumber
{
#if 0
    NSLog(@"TracksViewController::updateTrackButtons, track %d, gainPoints(0) = %0.0f",trackNumber,[[[[[self.tracks objectAtIndex:trackNumber] eq] gainPoints] objectAtIndex:0] floatValue]);
#endif
    
    TrackTableCell *cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:trackNumber inSection:0]];
    
    [cell.eqThumbView setNeedsDisplay];
}

- (void)updateSelectedTrack:(NSInteger)trackNumber
{
    self.selectedTrack = trackNumber;
}

#pragma mark -
#pragma mark Notification Handling Methods

- (void) updateVolumeFader:(NSNotification *)note
{
    

    NSDictionary *extraInfo = [note userInfo];
    int trackNumber = [[extraInfo objectForKey:@"trackNumber"] intValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:trackNumber inSection:0];
//
//  
//  
    TrackTableCell *cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:indexPath];
    
    //UISlider *volumeSlider = [volumeSliders objectForKey:[NSString stringWithFormat:@"%d",trackNumber]];
    
    
#if 0
    NSLog(@"Received trackVolumeDidChange notification, trackNumber = %d, volume = %0.3f",trackNumber,[[tracks objectAtIndex:trackNumber] volume]);
    NSLog(@"cell = 0x%x",(unsigned int)cell);
#endif    
    

    
    dispatch_async( dispatch_get_main_queue(), ^{
        // running synchronously on the main thread now -- call the handler
        cell.volumeSlider.value = [[tracks objectAtIndex:trackNumber] volume];
    });

    
    //volumeSlider.value = [[tracks objectAtIndex:trackNumber] volume];
  
    //cell.trackLabel.backgroundColor = [UIColor orangeColor];
    //cell.volumeSlider.value = [[tracks objectAtIndex:trackNumber] volume];
    
    //[self.tracksTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];

    //[self.tracksTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];  
    
    //cell.volumeSlider.value = [[tracks objectAtIndex:trackNumber] volume];
    //cell.trackLabel.backgroundColor = [UIColor orangeColor];
    
    //[tracksTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:0];
    
 
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
