//
//  DetailedChannelViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 7/29/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedChannelViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *detailedChannelScrollView;
@property (strong, nonatomic) UIButton *closeDetailedChannelViewButton;

- (void)closeDetailedChannelView:(id)sender;

@end
