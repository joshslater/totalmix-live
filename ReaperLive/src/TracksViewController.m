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
#import "EqButton.h"
#import "Eq.h"

@interface TracksViewController ()

@end

@implementation TracksViewController

#pragma mark Properties

@synthesize nTracks;
@synthesize currentRow;
@synthesize rowTracks;

@synthesize oscDelegate;
@synthesize tracks;
@synthesize tracksTableView;
@synthesize trackTableCell;
@synthesize tracksToolbar;
@synthesize selectedTrack;

// override setter for selected track
- (void)setSelectedTrack:(NSInteger)aSelectedTrack
{
    // set previously selected track to grey
    TrackTableCell *cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedTrack-1 inSection:0]];
    
    cell.trackLabel.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    selectedTrack = aSelectedTrack;
    
    if(selectedTrack != -1)
    {
        // change the label background of the selected track
        cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedTrack-1 inSection:0]];
        
        cell.trackLabel.layer.backgroundColor = [UIColor blackColor].CGColor;
    }
}

- (void)setCurrentRow:(NSInteger)aCurrentRow
{
    currentRow = aCurrentRow;
    
    rowTracks = [tracks objectAtIndex:aCurrentRow];
    // update OSC's rowtracks
    oscDelegate.rowTracks = rowTracks;
    
#if 0
    NSLog(@"tracksViewController.rowTracks = %x",(int)rowTracks);
#endif
}

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // create UITabBarItem
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Tracks" image:[UIImage imageNamed:@"TracksIcon.png"] tag:0];
    }
    
    // register for track volume updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVolumeFader:) name:@"TrackVolumeDidChange" object:nil];
    
    // register for track vu updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVuMeter:) name:@"TrackVuDidChange" object:nil];
    
    // register for track name updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrackName:) name:@"TrackNameDidChange" object:nil];
        
    // allocate the trackCells dict
    trackCells = [[NSMutableDictionary alloc] initWithCapacity:100];
    
    // allocate rowTracks
    rowTracks = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)initializeTracks
{
    for(int i = 0; i < 3; i++)
    {
        [tracks addObject:[[NSMutableArray alloc] init]];
    }
}

- (void)loadView
{
#if 0
    NSLog(@"TracksViewController::loadView");
#endif
    
    [super loadView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    /****************************/
    /********* TOOLBAR **********/
    /****************************/
    NSMutableArray *items = [[NSMutableArray alloc] init];
    // button to tell Reaper to update devices
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Refesh OSC" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshOSCButtonPressed:)]];
    [tracksToolbar setItems:items animated:NO];
    [self.view addSubview:tracksToolbar];
    
    // add tracks view
    tracksTableView = [[UITableView alloc] init];
    
    // Rotates the view.
    self.tracksTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);  
    
#if 0
    NSLog(@"Tab Bar Height = %0.0f",[super tabBarController].tabBar.frame.size.height);
#endif
    
    // why do I have to add 1 to the height?
    tracksTableView.frame = CGRectMake(0, tracksToolbar.frame.size.height, 8 * TRACK_CELL_WIDTH, screenRect.size.width - [[UIApplication sharedApplication] statusBarFrame].size.width - tracksToolbar.frame.size.height - [super tabBarController].tabBar.frame.size.height + 1);
    
    tracksTableView.delegate = self;
    tracksTableView.dataSource = self;
    
    // disable scrolling
    tracksTableView.scrollEnabled = NO;
    [self.view addSubview:tracksTableView];
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

    
    /////////////////////////////////////////////
    // create detailed track view controller //
    /////////////////////////////////////////////
    detailedTrackViewController = [[DetailedTrackViewController alloc] init];  
    // set the delegate of the detailedTrackViewController
    detailedTrackViewController.delegate = self;
        
    // set the initial track selection to -1 (no track selected)
    self.selectedTrack = -1;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // reload the data whenever the view will appear
    [tracksTableView reloadData];
    
    // scroll the tableview to the top
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tracksTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
#if 0
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice beginGeneratingDeviceOrientationNotifications];
    UIDeviceOrientation currentOrientation = [myDevice orientation];
    [myDevice endGeneratingDeviceOrientationNotifications];
    
    
    NSLog(@"Orientation = %d",currentOrientation);
#endif
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -
#pragma mark TableView Delegate/DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#if 1
    NSLog(@"numberofRowsInSection:%d",[(NSNumber *)[nTracks objectAtIndex:currentRow] intValue]);
#endif
    
    return [(NSNumber *)[nTracks objectAtIndex:currentRow] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 0
    NSLog(@"cellForRowAtIndexPath");
#endif
    
    TrackTableCell *cell;
    NSNumber *key = [NSNumber numberWithInt:indexPath.row];
    
    if ([trackCells objectForKey:key])
    {
#if 0
        NSLog(@"getting cell %d",indexPath.row);
#endif
        
        cell = (TrackTableCell *)[trackCells objectForKey:key];
        
        // set the volume slider, since we don't update it if it's not visible
        cell.volumeSlider.value = [[self.rowTracks objectAtIndex:indexPath.row] volume];
    } 
    else 
    {
#if 0
        NSLog(@"creating cell %d",indexPath.row);
#endif
        
        cell = [self createCell:((Track *)[rowTracks objectAtIndex:indexPath.row]).trackNumber];
        [trackCells setObject:cell forKey:key];        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRACK_CELL_WIDTH;
}

- (TrackTableCell *)createCell:(int)trackNumber
{
#if 0
    NSLog(@"TracksViewController::createCell:%d",trackNumber);
#endif
    
    TrackTableCell *cell;
    [[NSBundle mainBundle] loadNibNamed:@"TrackTableCell" owner:self options:nil];
    cell = [self trackTableCell];
    
#if 0   
    ////////////////////////////////
    ////// MANUAL CELL INIT/////////
    ////////////////////////////////
    
    cell = [[TrackTableCell alloc] initWithFrame:CGRectMake(0, 0, 85, 655)];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TrackBkg.png"]];
    
    /////////// GATE BUTTON ///////////////
    cell.gateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cell.gateButton.frame = CGRectMake(1, 8, 83, 83);
    [cell.gateButton setBackgroundImage:[UIImage imageNamed:@"GateBtn.png"] forState:UIControlStateNormal];
    [cell.gateButton addTarget:self action:@selector(gateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.gateButton];

    
    ////////// COMP BUTTON ///////////////
    cell.compButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cell.compButton.frame = CGRectMake(1, 95, 83, 83);
    [cell.compButton setBackgroundImage:[UIImage imageNamed:@"CompBtn.png"] forState:UIControlStateNormal];
    [cell.compButton addTarget:self action:@selector(compButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.compButton];
    
    //////////// EQ BUTTON ////////////
    cell.eqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cell.eqButton.frame = CGRectMake(1, 190, 83, 83);
    [cell.eqButton setBackgroundImage:[UIImage imageNamed:@"EQBtn.png"] forState:UIControlStateNormal];
    [cell.eqButton addTarget:self action:@selector(eqButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.eqButton];

    ////////// SOLO BUTTON ///////////
    UIButton *soloBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    soloBtn.frame = CGRectMake(6, 308, 33, 32);
    [soloBtn setBackgroundImage:[UIImage imageNamed:@"SoloBtn.png"] forState:UIControlStateNormal];
    [cell.contentView addSubview:soloBtn];
  
    ////////// MUTE BUTTON ///////////
    UIButton *muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    muteBtn.frame = CGRectMake(40, 308, 33, 32);
    [muteBtn setBackgroundImage:[UIImage imageNamed:@"MuteBtn.png"] forState:UIControlStateNormal];
    [cell.contentView addSubview:muteBtn];
    
    /////////// TRACK LABEL //////////
    cell.trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 348, 71, 45)];
    cell.trackLabel.textColor = [UIColor whiteColor];
    cell.trackLabel.highlightedTextColor = [UIColor whiteColor];
    cell.trackLabel.font = [UIFont systemFontOfSize:17.0];
    cell.trackLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:cell.trackLabel];
#endif     
    
    // create border
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    
    cell.trackLabel.text = ((Track *)[rowTracks objectAtIndex:trackNumber-1]).name;
    // give the track label rounded corners -- need to do this workaround as just
    // setting the cornerRadius kills scroll performance
    cell.trackLabel.backgroundColor = [UIColor clearColor];
    cell.trackLabel.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    cell.trackLabel.layer.cornerRadius = 6;
    cell.trackLabel.layer.shouldRasterize = YES;
    cell.trackLabel.layer.masksToBounds = NO;
    
    /**************************/
    /********* FADER  *********/
    /**************************/
    VolumeSlider *fader = [[VolumeSlider alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    [fader setRotatedThumbImage:[UIImage imageNamed:@"FaderCap.png"]];
    [fader setRotatedMinTrackImage:[UIImage imageNamed:@"VolumeSlider.png"]];
    [fader setRotatedMaxTrackImage:[UIImage imageNamed:@"VolumeSlider.png"]];
    
    [fader addTarget:self action:@selector(volumeFaderSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    fader.value = 0;
    
    // rotate the slider
    fader.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [cell.contentView addSubview:fader];
    
    //fader.bounds = CGRectMake(0, 0, 265, 30);
    fader.center = CGPointMake(70, 515);
    
    cell.volumeSlider = fader;        
    
    /**************************/
    /********** METER *********/
    /**************************/
    // Why do I need to set height to 206 even though image is only 202?
    VerticalSlider *meter = [[VerticalSlider alloc] initWithFrame:CGRectMake(0, 0, 206, 30)];
    
    // set the minimum track image
    [meter setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    
    // because of the way the rotation works out, actually need to set the
    // images opposite of their supposed names (min = max and vice versa)
    [meter setRotatedMinTrackImage:[UIImage imageNamed:@"MeterMax.png"]];
    [meter setRotatedMaxTrackImage:[UIImage imageNamed:@"MeterMin.png"]];
    
    meter.userInteractionEnabled = YES;
    
    // rotate meter
    meter.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [cell.contentView addSubview:meter];
    
    //meter.bounds = CGRectMake(0, 0, 202, 30);
    meter.center = CGPointMake(30, 515);
    
    cell.vuMeter = meter;
    
    // rotate the cell
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    
/*    
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
*/
    
    // set the eq for each of the eqThumbsView's
    cell.eqButton.eq = [[rowTracks objectAtIndex:trackNumber-1] eq];
    [cell.eqButton setNeedsDisplay];    
    return cell; 
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
#if 0
     NSLog(@"TracksViewController::scrollViewWillEndDragging:withVelocity:targetContentOffset:(%0.2f,%0.2f)",targetContentOffset->x,targetContentOffset->y);
#endif
    
    // calculate nearest cell
    float newTargetOffset = round(targetContentOffset->y / TRACK_CELL_WIDTH) * TRACK_CELL_WIDTH;
    
    *targetContentOffset = CGPointMake(targetContentOffset->x, newTargetOffset);
}

#pragma mark -
#pragma mark Action Handling

- (IBAction)gateButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];
    
    self.selectedTrack = indexPath.row;
    
#if 1
    NSLog(@"Gate Button Pushed for Track %d",indexPath.row);
#endif

    [self displayDetailedTrackViewControllerWithOffset:CGPointMake(0, 0)];
    
}

- (IBAction)compButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];

    self.selectedTrack = indexPath.row;
    
#if 1
    NSLog(@"Comp Button Pushed for Track %d",indexPath.row);
#endif
    
    [self displayDetailedTrackViewControllerWithOffset:CGPointMake(TRACKS_WIDTH, 0)];
}

- (IBAction)eqButtonPressed:(id)sender
{
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];
    
    self.selectedTrack = ((Track *)[self.rowTracks objectAtIndex:indexPath.row]).trackNumber;
    
#if 1
    NSLog(@"EQ Button Pushed for Track %d",indexPath.row);
#endif
    
    [self displayDetailedTrackViewControllerWithOffset:CGPointMake(2*TRACKS_WIDTH, 0)];
}

- (void)volumeFaderSliderAction:(UISlider *)sender
{
    NSIndexPath *indexPath = [self.tracksTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    Track *track = [self.rowTracks objectAtIndex:indexPath.row];
    
    track.volume = [sender value];
        
    // call the oscDelegate with the new value
    [oscDelegate volumeFaderDidChange:indexPath.row+1 toValue:[sender value]];

#if 0    
    NSLog(@"Set Track %d Volume to %0.3f",indexPath.row,[sender value]);
#endif
}

- (void)refreshOSCButtonPressed:(id)sender
{
#if 0    
    NSLog(@"Refresh OSC Button Pressed");
#endif
}

- (IBAction)setInputButtonPressed:(id)sender
{
    // setting current row will update rowTracks
    self.currentRow = 0;
    [self refreshTrackCells];
    [oscDelegate setBusInput];
    
    [tracksTableView reloadData];
}

- (IBAction)setPlaybackButtonPressed:(id)sender
{
    // setting current row will update rowTracks
    self.currentRow = 1;
    [self refreshTrackCells];
    [oscDelegate setBusPlayback];
    
    [tracksTableView reloadData];
}

- (IBAction)setOutputButtonPressed:(id)sender
{
    // setting current row will update rowTracks
    self.currentRow = 2;
    [self refreshTrackCells];
    [oscDelegate setBusOutput];
    
    [tracksTableView reloadData];
}

- (IBAction)trackPlus:(id)sender
{
    [oscDelegate trackPlusMinus:OSCIncrementTrack page:1];
}

- (IBAction)trackMinus:(id)sender
{
    [oscDelegate trackPlusMinus:OSCDecrementTrack page:1];
}

#pragma mark -
#pragma mark View Handling

- (void)displayDetailedTrackViewControllerWithOffset:(CGPoint)offset
{    
#if 0
    NSLog(@"TracksViewController: selectedTrack = %d",selectedTrack);
    NSLog(@"TracksViewController: gainPoint(0) = %0.0f",[[[[[self.rowTracks objectAtIndex:selectedTrack-1] eq] gainPoints] objectAtIndex:0] floatValue]);
    NSLog(@"gainPoints address = %x",(unsigned int)[[[self.rowTracks objectAtIndex:selectedTrack-1] eq] gainPoints]);
#endif
    

#if 0
    NSLog(@"setting detailedViewController.track to %x",(unsigned int)[self.rowTracks objectAtIndex:selectedTrack-1]);
#endif
    
    // pass the necessary properties about the cahnnel to the detailed view controller
    detailedTrackViewController.track = [self.rowTracks objectAtIndex:selectedTrack-1];
    detailedTrackViewController.selectedTrack = selectedTrack;
        
    // set content offset to be TRACKS_WIDTH
    detailedTrackViewController.contentOffset = offset;
    
    detailedTrackViewController.oscDelegate = (id <OSCMessagingProtocol>)oscDelegate;
    
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
    
    [cell.eqButton setNeedsDisplay];
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
    int visibleTrackNumber = [[extraInfo objectForKey:@"visibleTrackNumber"] intValue];
    float trackVolume = [[extraInfo objectForKey:@"trackVolume"] floatValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:visibleTrackNumber-1 inSection:0];

    TrackTableCell *cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:indexPath];
    
#if 0
    NSLog(@"Received trackVolumeDidChange notification, visibleTrackNumber = %d, volume = %0.3f",visibleTrackNumber,trackVolume);
    NSLog(@"cell = 0x%x",(unsigned int)cell);
#endif    
    
    dispatch_async( dispatch_get_main_queue(), ^{
        // running synchronously on the main thread now -- call the handler
        cell.volumeSlider.value = trackVolume;
    });
}

- (void) updateVuMeter:(NSNotification *)note
{
    NSDictionary *extraInfo = [note userInfo];
    int visibleTrackNumber = [[extraInfo objectForKey:@"visibleTrackNumber"] intValue];
    float meterLevel = [[extraInfo objectForKey:@"meterLevel"] floatValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:visibleTrackNumber-1 inSection:0];
    
    TrackTableCell *cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:indexPath];
    
#if 0
    NSLog(@"Received trackVuDidChange notification, visibleTrackNumber = %d, vu level = %0.3f",visibleTrackNumber,meterLevel);
    NSLog(@"cell = 0x%x",(unsigned int)cell);
#endif    
    
    dispatch_async( dispatch_get_main_queue(), ^{
        // running synchronously on the main thread now -- call the handler
        cell.vuMeter.value = meterLevel;
    });
}

- (void) updateTrackName:(NSNotification *)note
{
    NSDictionary *extraInfo = [note userInfo];
    int visibleTrackNumber = [[extraInfo objectForKey:@"visibleTrackNumber"] intValue];
    NSString *trackName = [extraInfo objectForKey:@"trackName"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:visibleTrackNumber-1 inSection:0];
    
    TrackTableCell *cell = (TrackTableCell *)[self.tracksTableView cellForRowAtIndexPath:indexPath];
    
#if 0
    NSLog(@"Received trackNameDidChange notification, visibleTrackNumber = %d, track name = %@",visibleTrackNumber,trackName);
    NSLog(@"cell = 0x%x",(unsigned int)cell);
#endif
    
    dispatch_async( dispatch_get_main_queue(), ^{
        // running synchronously on the main thread now -- call the handler
        cell.trackLabel.text = trackName;
    });
}



#pragma mark -
#pragma mark TracksViewControllerProtocol Implementation

- (void)refreshTracks
{
#if 0
    NSLog(@"tracksViewController::refreshTracks:[%d %d %d]",[(NSNumber *)[nTracks objectAtIndex:0] intValue],[(NSNumber *)[nTracks objectAtIndex:1] intValue],[(NSNumber *)[nTracks objectAtIndex:2] intValue]);
#endif
    
    // clear old tracks
    for (int i = 0; i < 3; i++)
    {
        [[self.tracks objectAtIndex:i] removeAllObjects];
    
        for (int j = 0; j < MAX([(NSNumber *)[nTracks objectAtIndex:i] intValue],8); j++)
        {
#if 0
            NSLog(@"refreshTracks:: i = %d, j = %d",i,j);
#endif
            
            [[self.tracks objectAtIndex:i] addObject: [[Track alloc] initWithTrackNumber:(j+1)]];
        }
    }
}

- (void)refreshTrackCells
{
#if 0
    NSLog(@"tracksViewController::refreshTrackCells:[%d %d %d]",[(NSNumber *)[nTracks objectAtIndex:0] intValue],[(NSNumber *)[nTracks objectAtIndex:1] intValue],[(NSNumber *)[nTracks objectAtIndex:2] intValue]);
#endif
    
    // clear old track cells
    [trackCells removeAllObjects];
        
    // initialize track cell array
    for (int cellNum = 0; cellNum < [(NSNumber *)[nTracks objectAtIndex:self.currentRow] intValue]; cellNum++)
    {
#if 0
        NSLog(@"creating cell %d",((Track *)[rowTracks objectAtIndex:cellNum]).trackNumber);
#endif
        
        TrackTableCell *cell = [self createCell:((Track *)[rowTracks objectAtIndex:cellNum]).trackNumber];
        [trackCells setObject:cell forKey:[NSNumber numberWithInt:cellNum]];
    }
}

- (void)tracksDidUpdate
{
//    // reload the data whenever the view will appear
//    [tracksTableView reloadData];
//    
//    // scroll the tableview to the top
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [tracksTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
