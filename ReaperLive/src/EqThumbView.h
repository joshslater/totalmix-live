//
//  EqThumbView.h
//  ReaperLive
//
//  Created by Josh Slater on 8/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EqThumbView : UIView

@property (strong, nonatomic) NSNumber *nPoints;
@property (strong, nonatomic) NSMutableArray *eqFreqPoints;
@property (strong, nonatomic) NSMutableArray *eqCurve;

@end
