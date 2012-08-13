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

@property (nonatomic, strong) EQView *eqView;

@property (strong, nonatomic) EqCurveView *eqCurveView;
@property (strong, nonatomic) EqPointsView *eqPointsView;


@property (strong, nonatomic) IBOutletCollection(MHRotaryKnob) NSArray *gainKnobs;
@property (strong, nonatomic) IBOutletCollection(MHRotaryKnob) NSArray *freqKnobs;
@property (strong, nonatomic) IBOutletCollection(MHRotaryKnob) NSArray *qKnobs;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gainLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *freqLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *qLabels;



@property (strong, nonatomic) NSMutableArray *gainPoints;
@property (strong, nonatomic) NSMutableArray *freqPoints;

@end
