//
//  EqPointsView.h
//  ReaperLive
//
//  Created by Josh Slater on 8/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EqPointsView : UIView

@property (nonatomic, strong) NSMutableArray *gainPoints;
@property (nonatomic, strong) NSMutableArray *freqPoints;

@property (strong, nonatomic) NSMutableArray *eqPointImages;

- (void)updateEqPoints;

@end
