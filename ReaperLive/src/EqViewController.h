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
@class Eq;

typedef enum
{
    EQItemGain,
    EQItemFrequency,
    EQItemQ    
} eqItems_t;

@protocol EqOscProtocol <NSObject>
- (void)eqValueDidChange:(NSInteger)trackNumber band:(NSInteger)band item:(eqItems_t)item value:(float)value;
@end

@interface EqViewController : UIViewController
{
    int selectedBand;
    EqCurveView *eqCurveView;
    EqPointsView *eqPointsView;
}

@property (nonatomic, weak) id <EqOscProtocol> oscDelegate;
@property (nonatomic, strong) EQView *eqView;
@property (weak, nonatomic) IBOutlet MHRotaryKnob *gainKnob;
@property (weak, nonatomic) IBOutlet MHRotaryKnob *freqKnob;
@property (weak, nonatomic) IBOutlet MHRotaryKnob *qKnob;
@property (weak, nonatomic) IBOutlet UILabel *gainLabel;
@property (weak, nonatomic) IBOutlet UILabel *freqLabel;
@property (weak, nonatomic) IBOutlet UILabel *qLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bandSelector;
@property int trackNumber;
@property (strong, nonatomic) Eq *eq;



@end
