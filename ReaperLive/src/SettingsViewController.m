//
//  SettingsViewController.m
//  ReaperLive
//
//  Created by Josh Slater on 8/27/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize oscSettingsDelegate;

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
    
    oscIpAddressElement = [[QEntryElement alloc] initWithTitle:@"IP Address" Value:@"192.168.1.133" Placeholder:@"192.168.1.133"];
    oscIpAddressElement.keyboardType = UIKeyboardTypeNumberPad;
    oscIpAddressElement.delegate = self;
    [section addElement:oscIpAddressElement];   
    
    oscOutPortElement = [[QEntryElement alloc] initWithTitle:@"Outgoing Port" Value:@"8000" Placeholder:@"8000"];
    oscOutPortElement.keyboardType = UIKeyboardTypeNumberPad;
    oscOutPortElement.delegate = self;
    [section addElement:oscOutPortElement];
    
    oscInPortElement = [[QEntryElement alloc] initWithTitle:@"Incoming Port" Value:@"9000" Placeholder:@"9000"];
    oscInPortElement.keyboardType = UIKeyboardTypeNumberPad;
    oscInPortElement.delegate = self;
    [section addElement:oscInPortElement];
    
    QButtonElement *testOscButtonElement = [[QButtonElement alloc] initWithTitle:@"Send OSC Test Message"];
    testOscButtonElement.controllerAction = @"sendTestOscMsg";

    [section addElement:testOscButtonElement];    
    
    // for now, just create the object straight away
    NSNumber *inPort = [NSNumber numberWithInt:[oscInPortElement.textValue intValue]];
    NSNumber *outPort = [NSNumber numberWithInt:[oscOutPortElement.textValue intValue]];
    [oscSettingsDelegate updateOscIpAddress:oscIpAddressElement.textValue inPort:inPort outPort:outPort];
    
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
#if 0    
    NSLog(@"Done Editing Element");
#endif
    
    NSNumber *inPort = [NSNumber numberWithInt:[oscInPortElement.textValue intValue]];
    NSNumber *outPort = [NSNumber numberWithInt:[oscOutPortElement.textValue intValue]];
    
    [oscSettingsDelegate updateOscIpAddress:oscIpAddressElement.textValue inPort:inPort outPort:outPort];
}

- (void)sendTestOscMsg
{
#if 0
    NSLog(@"settingsViewController::sendTestOscMsg");
#endif
    
    [oscSettingsDelegate sendTestOscMsg];
}

@end
