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

@interface DetailedChannelViewController : UIViewController <UIScrollViewDelegate>
{
    EQView *eqView;
    CompView *compView;
    GateView *gateView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *detailedChannelScrollView;
@property (strong, nonatomic) UIButton *closeDetailedChannelViewButton;

- (void)closeDetailedChannelView:(id)sender;

@end
