//
//  EQView.h
//  ReaperLive
//
//  Created by Josh Slater on 7/25/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHRotaryKnob;

@interface EQView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutletCollection(MHRotaryKnob) NSArray *gainKnobs;
@property (strong, nonatomic) IBOutletCollection(MHRotaryKnob) NSArray *freqKnobs;
@property (strong, nonatomic) IBOutletCollection(MHRotaryKnob) NSArray *qKnobs;

@end
