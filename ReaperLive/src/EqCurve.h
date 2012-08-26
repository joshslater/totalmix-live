//
//  EqCurve.h
//  ReaperLive
//
//  Created by Josh Slater on 8/19/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EqCurve : NSObject
{
    NSMutableArray *w;
    NSMutableArray *z;
    double fs;
}

@property (nonatomic, strong) NSMutableArray *gainPoints;
@property (nonatomic, strong) NSMutableArray *freqPoints;
@property (nonatomic, strong) NSMutableArray *qPoints;

@property (nonatomic, strong) NSNumber *nPoints;
@property (nonatomic, strong) NSMutableArray *eqFreqPoints;
@property (nonatomic, strong) NSMutableArray *HArray;

@property (nonatomic, strong) NSMutableArray *eqCurve;

@property (nonatomic, strong) NSNumber *selectedBand;

-(void)calculateEqCurve;

@end
