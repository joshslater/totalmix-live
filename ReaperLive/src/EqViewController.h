//
//  EqViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EQView;
@class EqPointsView;
@class EqCurveView;
@class MHRotaryKnob;

@interface EqViewController : UIViewController
{
    int selectedBand;
}

@property (nonatomic, strong) EQView *eqView;

@property (strong, nonatomic) EqCurveView *eqCurveView;
@property (strong, nonatomic) EqPointsView *eqPointsView;


@property (strong, nonatomic) IBOutlet MHRotaryKnob *gainKnob;
@property (strong, nonatomic) IBOutlet MHRotaryKnob *freqKnob;
@property (strong, nonatomic) IBOutlet MHRotaryKnob *qKnob;

@property (strong, nonatomic) IBOutlet UILabel *gainLabel;
@property (strong, nonatomic) IBOutlet UILabel *freqLabel;
@property (strong, nonatomic) IBOutlet UILabel *qLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *bandSelector;

@property (strong, nonatomic) NSMutableArray *gainPoints;
@property (strong, nonatomic) NSMutableArray *freqPoints;
@property (strong, nonatomic) NSMutableArray *qPoints;

@end
