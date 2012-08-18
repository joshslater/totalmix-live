//
//  DetailedChannelViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 7/29/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EQView;
@class CompView;
@class GateView;
@class EqViewController;
@class Channel;

@interface DetailedChannelViewController : UIViewController <UIScrollViewDelegate>
{
    EQView *eqView;
    CompView *compView;
    GateView *gateView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *detailedChannelScrollView;
@property (strong, nonatomic) UIButton *closeDetailedChannelViewButton;

@property (strong, nonatomic) EqViewController *eqViewController;

@property (nonatomic) NSInteger selectedChannel;
@property (strong, nonatomic) Channel *channel;

- (void)closeDetailedChannelView:(id)sender;

@end
