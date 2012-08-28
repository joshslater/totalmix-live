//
//  Eq.m
//  ReaperLive
//
//  Created by Josh Slater on 8/19/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Constants.h"
#import "Eq.h"
#import "Complex.h"

@implementation Eq

@synthesize gainPoints;
@synthesize freqPoints;
@synthesize qPoints;

@synthesize nPoints;
@synthesize eqFreqPoints;
@synthesize eqCurve;

@synthesize selectedBand;

-(Eq *)init
{
    if (self = [super init])
    {
        fs = 44100;        
        
        // Initialization code here
        nPoints = [NSNumber numberWithInt:1000];
        HArray = [[NSMutableArray alloc] init];
        eqFreqPoints = [[NSMutableArray alloc] init];
        eqCurve = [[NSMutableArray alloc] init];
        
        // number of frequency points
        double wMin = DET_EQ_MIN_FREQ / fs * (2 * M_PI);
        double wMax = DET_EQ_MAX_FREQ / fs * (2 * M_PI);
        double logWRange = log10(wMax) - log10(wMin);
        
        double wStep = logWRange/[nPoints intValue];
        
#if 0
        NSLog(@"wStep = %0.3f", wStep);
#endif
        
        // initialize omega (w) and z
        w = [[NSMutableArray alloc] initWithCapacity:[nPoints intValue]];
        z = [[NSMutableArray alloc] initWithCapacity:[nPoints intValue]];

        
        for (int j = 0; j < 4; j++)
        {
            [HArray addObject:[[NSMutableArray alloc] init]];
            
            NSMutableArray *H = [HArray objectAtIndex:j];
            
            // set all eqCurve points to unity
            for (int i = 0; i <= [nPoints intValue]; i++)
            {
                [H addObject:[[Complex alloc] initWithReal:1 andImag:0]];
            }
        }
             
        // set all eqCurve points to 0
        for (int i = 0; i <= [nPoints intValue]; i++)
        {
            double wVal = pow(10,log10(wMin) + i*wStep);
            
#if 0
            NSLog(@"wVal = %0.3f, fVal = %0.3f",wVal,fVal);
#endif
            
            [eqCurve addObject:[NSNumber numberWithDouble:0]];
            [w addObject:[NSNumber numberWithFloat:wVal]];
            [z addObject:[[Complex alloc] initWithReal:cos(-wVal) andImag:sin(-wVal)]];
            [eqFreqPoints addObject:[NSNumber numberWithDouble:wVal/M_PI*fs/2]];
        }
        
    }
    return self;
}

-(void)calculateEqCurve
{
#if 0
    NSLog(@"in calculateEqCurve, selectedBand = %d",[selectedBand integerValue]);
#endif
    
    double fc = [[freqPoints objectAtIndex:[selectedBand integerValue]] doubleValue];
    double q = [[qPoints objectAtIndex:[selectedBand integerValue]] doubleValue];
    double g = [[gainPoints objectAtIndex:[selectedBand integerValue]] doubleValue];
    
    double A = sqrt(pow(10, g/20));
    double wc = 2*M_PI*fc / fs;
    double wS = sin(wc);
    double wC = cos(wc);
    double alpha = wS/(2*q);
    double beta = sqrt(A)/q;
    
    double b0, b1, b2, a0, a1, a2;
    
    switch([selectedBand integerValue])
    {
        case 0:
            // low shelf
            b0 = A*((A+1)-((A-1)*wC)+(beta*wS));
            b1 = 2*A*((A-1)-((A+1)*wC));
            b2 = A*((A+1)-((A-1)*wC)-(beta*wS));
            a0 = ((A+1)+((A-1)*wC)+(beta*wS));
            a1 = -2*((A-1)+((A+1)*wC));
            a2 = ((A+1)+((A-1)*wC)-(beta*wS));
            break;
            
        case 3:
            // high shelf
            b0 = A*((A+1)+((A-1)*wC)+(beta*wS));
            b1 = -2*A*((A-1)+((A+1)*wC));
            b2 = A*((A+1)+((A-1)*wC)-(beta*wS));
            a0 = ((A+1)-((A-1)*wC)+(beta*wS));
            a1 = 2*((A-1)-((A+1)*wC));
            a2 = ((A+1)-((A-1)*wC)-(beta*wS));
            break;
            
        default:
            // peaking EQ
            b0 = 1+(alpha*A);
            b1 = -2*wC;
            b2 = 1-(alpha*A);
            a0 = 1+(alpha/A);
            a1 = -2*wC;
            a2 = 1-(alpha/A);
            break;
    }
    
//    % % low pass filter
//    % b0 = (1 - wC)/2;
//    % b1 = 1 - wC;
//    % b2 = (1 - wC)/2;
//    % a0 = 1 + alpha;
//    % a1 = -2*wC;
//    % a2 = 1 - alpha;
//    
    
    Complex *num = [[Complex alloc] init];
    Complex *num1 = [[Complex alloc] init];
    Complex *num2 = [[Complex alloc] init];
    
    Complex *den = [[Complex alloc] init];
    Complex *den1 = [[Complex alloc] init];
    Complex *den2 = [[Complex alloc] init];
    
    Complex *result = [[Complex alloc] init];
        
    NSMutableArray *H = [HArray objectAtIndex:[selectedBand integerValue]];
    
    for (int i = 0; i <= [nPoints intValue]; i++)
    {        
        Complex *zVal = [z objectAtIndex:i];        
        
        [num1 rmult:[num1 pow:zVal exp:-1] withReal:b1];
        [num2 rmult:[num2 pow:zVal exp:-2] withReal:b2];
        
        [num add:[num radd:num1 withReal:b0] :num2];
        
        [den1 rmult:[den1 pow:zVal exp:-1] withReal:a1];
        [den2 rmult:[den2 pow:zVal exp:-2] withReal:a2];
        
        [den add:[den radd:den1 withReal:a0] :den2];
        
        [result div:num :den];
        
        [H replaceObjectAtIndex:i withObject:[[Complex alloc] initWithReal:result.real andImag:result.imag]];

#if 0
        NSLog(@"abs(num1) @ w = %0.3f = %0.3f",[[w objectAtIndex:i] doubleValue],num1.abs);
#endif
    }
    
    for (int i = 0; i <= [nPoints intValue]; i++)
    {
        Complex *eqCurveVal = [[Complex alloc] initWithReal:[[[HArray objectAtIndex:0] objectAtIndex:i] real] andImag:[[[HArray objectAtIndex:0] objectAtIndex:i] imag]];
        
        // recalculate eqCurve
        for (int j = 1; j < 4; j++)
        {
            [eqCurveVal mult:eqCurveVal :[[HArray objectAtIndex:j] objectAtIndex:i]];
        }

        [eqCurve replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:20*log10([eqCurveVal abs])]];

    }
    
//    // add some known point
//    [eqCurve replaceObjectAtIndex:20 withObject:[NSNumber numberWithDouble:20]];

}

@end
