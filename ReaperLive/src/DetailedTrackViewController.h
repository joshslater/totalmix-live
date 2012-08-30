//
//  DetailedTrackViewController.h
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
@class Track;

@protocol DetailedTrackViewControllerProtocol <NSObject>
@required
- (void)updateTrackButtons:(NSInteger)trackNumber;
@end


@interface DetailedTrackViewController : UIViewController <UIScrollViewDelegate>
{
    CompView *compView;
    GateView *gateView;
    EqViewController *eqViewController;
    UIButton *closeDetailedTrackViewButton;
    UIScrollView *detailedTrackScrollView;

}

@property (weak, nonatomic) id <DetailedTrackViewControllerProtocol> delegate;

@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) NSInteger selectedTrack;
@property (strong, nonatomic) Track *track;

- (void)closeDetailedTrackView:(id)sender;

@end
