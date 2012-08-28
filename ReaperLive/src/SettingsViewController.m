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
    
    QEntryElement *ipAddress = [[QEntryElement alloc] initWithTitle:@"IP Address" Value:nil Placeholder:@"127.0.0.1"];
    ipAddress.keyboardType = UIKeyboardTypeNumberPad;
    
    [root addSection:section];
    [section addElement:ipAddress];   
    
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


@end
