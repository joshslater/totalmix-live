//
//  EqCurveView.h
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EqCurveView : UIView

@property (nonatomic, strong) NSNumber *nPoints;

@property (nonatomic, strong) NSMutableArray *eqFreqPoints;
@property (nonatomic, strong) NSMutableArray *eqCurve;

@end
