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
    EQView *eqView;
    CompView *compView;
    GateView *gateView;
}

@property (weak, nonatomic) id <DetailedTrackViewControllerProtocol> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *detailedTrackScrollView;
@property (strong, nonatomic) UIButton *closeDetailedTrackViewButton;

@property (strong, nonatomic) EqViewController *eqViewController;

@property (nonatomic) NSInteger selectedTrack;
@property (strong, nonatomic) Track *track;

- (void)closeDetailedTrackView:(id)sender;

@end
