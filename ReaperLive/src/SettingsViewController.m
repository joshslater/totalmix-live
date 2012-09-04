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

@synthesize settings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:0];
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
    
    // no matter who was edited, update the osc delegate
    [oscSettingsDelegate updateOscIpAddress:oscIpAddressElement.textValue inPort:self.settings.oscInPort outPort:self.settings.oscOutPort];
}

- (void)sendTestOscMsg
{
#if 0
    NSLog(@"settingsViewController::sendTestOscMsg");
#endif
    
    [oscSettingsDelegate sendTestOscMsg];
}


@end
