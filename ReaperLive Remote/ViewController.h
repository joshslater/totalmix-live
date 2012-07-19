//
//  ViewController.h
//  ReaperLive Remote
//
//  Created by Josh Slater on 7/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView *channelsTableView;
@property NSMutableArray *channelsArray;

@end
