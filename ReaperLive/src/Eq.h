//
//  Eq.h
//  ReaperLive
//
//  Created by Josh Slater on 8/19/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Eq : NSObject
{
    NSMutableArray *w;
    NSMutableArray *z;
    double fs;
    NSMutableArray *HArray;
}

@property (nonatomic, strong) NSMutableArray *gainPoints;
@property (nonatomic, strong) NSMutableArray *freqPoints;
@property (nonatomic, strong) NSMutableArray *qPoints;

@property (nonatomic, strong) NSNumber *nPoints;

@property (nonatomic, strong) NSMutableArray *eqFreqPoints;
@property (nonatomic, strong) NSMutableArray *eqCurve;

-(void)calculateEqCurve:(NSNumber*)band;

@end
