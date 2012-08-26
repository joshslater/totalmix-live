//
//  Complex.m
//  ReaperLive
//
//  Created by Josh Slater on 8/25/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "Complex.h"

@implementation Complex

-(Complex *) init
{
    self = [super init];
    
    if(self)
    {
        real = 0;
        imag = 0;
    }
    
    return self;
}

-(Complex *) initWithReal: (double) r andImag: (double) i
{
    self = [super init];

    if ( self ) 
    {
        [self setReal: r andImag: i];
    }

    return self;
}

-(void) setReal: (double) r 
{
    real = r;
}

-(void) setImag: (double) i 
{
    imag = i;
}

-(void) setReal: (double) r andImag: (double) i 
{
    real = r;
    imag = i;
}

-(double) real
{
    return real;
}

-(double) imag
{
    return imag;
}

-(double) abs
{
    return sqrt(pow(self.real,2) + pow(self.imag,2));
}

-(Complex *) add: (Complex *) c1 : (Complex *) c2
{
    self.real = c1.real + c2.real;
    self.imag = c1.imag + c2.imag;
    
    return self;
}

-(Complex *) radd: (Complex *) c withReal: (double) r
{
    self.real = r + c.real;
    self.imag = c.imag;
    
    return self;
}

-(Complex *) mult: (Complex *) c1 : (Complex *) c2
{
    double realTmp = c1.real * c2.real - c1.imag * c2.imag;
    self.imag = c1.real * c2.imag + c2.real * c1.imag;
    self.real = realTmp;
    
    return self;
}

-(Complex *) rmult: (Complex *) c withReal: (double) r
{
    self.real = r * c.real;
    self.imag = r * c.imag;
    
    return self;
}

-(Complex *) div: (Complex *) num : (Complex *) den
{
    double dv;
    
    dv =  den.real * den.real + den.imag * den.imag;
    self.real = (num.real * den.real + num.imag * den.imag) / dv;
    self.imag = (num.imag * den.real - num.real * den.imag) / dv; 
    
    return self; 
}

-(Complex *) pow: (Complex *) c exp: (double) p
{
    double r = c.abs;
    double theta = atan2(c.imag, c.real);
    
    self.real = pow(r,p) * cos(p * theta);
    self.imag = pow(r,p) * sin(p * theta);
    
    return self;
}

@end
