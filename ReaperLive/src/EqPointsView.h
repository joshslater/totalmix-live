//
//  EqPointsView.h
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Eq;

@interface EqPointsView : UIView

@property (nonatomic, strong) Eq *eq;

@property (strong, nonatomic) NSMutableArray *eqPointImages;

- (void)updateEqPoints;

@end
