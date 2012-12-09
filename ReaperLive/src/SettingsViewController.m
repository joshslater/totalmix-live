//
//  SettingsViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/27/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize oscSettingsDelegate;
@synthesize tracksViewControllerDelegate;

@synthesize settings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"SettingsIcon.png"] tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    oscIpAddressElement.textValue = self.settings.oscIpAddress;
    if(self.settings.oscInPort != 0)
        oscInPortElement.textValue = [NSString stringWithFormat:@"%d",self.settings.oscInPort];
    
    if(self.settings.oscOutPort != 0)
        oscOutPortElement.textValue = [NSString stringWithFormat:@"%d",self.settings.oscOutPort];
    
    if([(NSNumber *)[self.settings.nTracks objectAtIndex:0] intValue] != 0)
        nInputTracksElement.textValue = [NSString stringWithFormat:@"%d",[(NSNumber *)[self.settings.nTracks objectAtIndex:0] intValue]];
    
    if([(NSNumber *)[self.settings.nTracks objectAtIndex:1] intValue] != 0)
        nPlaybackTracksElement.textValue = [NSString stringWithFormat:@"%d",[(NSNumber *)[self.settings.nTracks objectAtIndex:1] intValue]];
    
    if([(NSNumber *)[self.settings.nTracks objectAtIndex:2] intValue] != 0)
        nOutputTracksElement.textValue = [NSString stringWithFormat:@"%d",[(NSNumber *)[self.settings.nTracks objectAtIndex:2] intValue]];
}

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];

    self.quickDialogTableView.styleProvider = self;
}

- (void)loadView
{
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Settings";
    root.grouped = YES;
    QSection *section = [[QSection alloc] init];
    section.title = @"OSC Parameters";

    [root addSection:section];
    
    oscIpAddressElement = [[QEntryElement alloc] initWithTitle:@"IP Address" Value:nil Placeholder:@"xxx.xxx.xxx.xxx"];
    oscIpAddressElement.keyboardType = UIKeyboardTypeNumberPad;
    oscIpAddressElement.delegate = self;
    oscIpAddressElement.key = kIpAddressKey;
    [section addElement:oscIpAddressElement];   
    
    oscOutPortElement = [[QEntryElement alloc] initWithTitle:@"Outgoing Port" Value:nil Placeholder:@"xxxx"];
    oscOutPortElement.keyboardType = UIKeyboardTypeNumberPad;
    oscOutPortElement.delegate = self;
    oscOutPortElement.key = kOutPortKey;
    [section addElement:oscOutPortElement];
    
    oscInPortElement = [[QEntryElement alloc] initWithTitle:@"Incoming Port" Value:nil Placeholder:@"xxxx"];
    oscInPortElement.keyboardType = UIKeyboardTypeNumberPad;
    oscInPortElement.delegate = self;
    oscInPortElement.key = kInPortKey;
    [section addElement:oscInPortElement];
    
    QButtonElement *testOscButtonElement = [[QButtonElement alloc] initWithTitle:@"Send OSC Test Message"];
    testOscButtonElement.controllerAction = @"sendTestOscMsg";
    [section addElement:testOscButtonElement];
    
    nInputTracksElement = [[QEntryElement alloc] initWithTitle:@"Number of Input Tracks" Value:nil Placeholder:@"15"];
    nInputTracksElement.keyboardType = UIKeyboardTypeNumberPad;
    nInputTracksElement.delegate = self;
    nInputTracksElement.key = kNInputTracksKey;
    [section addElement:nInputTracksElement];
    
    nPlaybackTracksElement = [[QEntryElement alloc] initWithTitle:@"Number of Playback Tracks" Value:nil Placeholder:@"15"];
    nPlaybackTracksElement.keyboardType = UIKeyboardTypeNumberPad;
    nPlaybackTracksElement.delegate = self;
    nPlaybackTracksElement.key = kNPlaybackTracksKey;
    [section addElement:nPlaybackTracksElement];
    
    nOutputTracksElement = [[QEntryElement alloc] initWithTitle:@"Number of Output Tracks" Value:nil Placeholder:@"15"];
    nOutputTracksElement.keyboardType = UIKeyboardTypeNumberPad;
    nOutputTracksElement.delegate = self;
    nOutputTracksElement.key = kNOutputTracksKey;
    [section addElement:nOutputTracksElement];
    
    self.root = root;
    [super loadView];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if ([element isKindOfClass:[QEntryElement class]])
    {
        ((QEntryTableViewCell *)cell).textField.textAlignment = UITextAlignmentRight;
    }   
}

- (void)QEntryDidEndEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
#if 1
    NSLog(@"Done Editing Element, key = %@",element.key);
#endif
    
    if([element.key isEqualToString:kIpAddressKey])
    {
        self.settings.oscIpAddress = oscIpAddressElement.textValue;
    }
    else if([element.key isEqualToString:kInPortKey])
    {
        self.settings.oscInPort = [oscInPortElement.textValue intValue];
    }
    else if([element.key isEqualToString:kOutPortKey])
    {
        self.settings.oscOutPort = [oscOutPortElement.textValue intValue];
    }
    else if([element.key isEqualToString:kNInputTracksKey])
    {
        [self.settings.nTracks replaceObjectAtIndex:0 withObject:[[NSNumber alloc] initWithInt:[nInputTracksElement.textValue intValue]]];
    }
    else if([element.key isEqualToString:kNPlaybackTracksKey])
    {
        [self.settings.nTracks replaceObjectAtIndex:1 withObject:[[NSNumber alloc] initWithInt:[nPlaybackTracksElement.textValue intValue]]];
    }
    else if([element.key isEqualToString:kNOutputTracksKey])
    {
        [self.settings.nTracks replaceObjectAtIndex:2 withObject:[[NSNumber alloc] initWithInt:[nOutputTracksElement.textValue intValue]]];
    }
    
    // no matter who was edited, update the osc delegate
    [oscSettingsDelegate updateOscIpAddress:oscIpAddressElement.textValue inPort:self.settings.oscInPort outPort:self.settings.oscOutPort];
    
    // initialize tracks
    [tracksViewControllerDelegate setNTracks:self.settings.nTracks];
    [tracksViewControllerDelegate refreshTracks];
    [tracksViewControllerDelegate refreshTrackCells];
    [tracksViewControllerDelegate tracksDidUpdate];
    
}

- (void)sendTestOscMsg
{
#if 0
    NSLog(@"settingsViewController::sendTestOscMsg");
#endif
    
    [oscSettingsDelegate sendTestOscMsg];
}


@end
