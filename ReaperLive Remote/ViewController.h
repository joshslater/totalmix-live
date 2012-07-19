//
//  ViewController.h
//  ReaperLive Remote
//
//  Created by Josh Slater on 7/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *channelsTableView;
@property (nonatomic, retain) NSMutableArray *channelsArray;


- (IBAction)eqButtonPressed:(id)sender;

@end
