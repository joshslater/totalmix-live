//
//  Complex.h
//  ReaperLive
//
//  Created by Josh Slater on 8/25/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Complex: NSObject {
    double real;
    double imag;
}

-(Complex *) initWithReal: (double) r andImag: (double) i;
-(void) setReal: (double) r;
-(void) setImag: (double) i;
-(void) setReal: (double) r andImag: (double) i;
-(double) real;
-(double) imag;
-(double) abs;

-(Complex *) add: (Complex *) c1 : (Complex *) c2;
-(Complex *) radd: (Complex *) c withReal: (double) r;

-(Complex *) mult: (Complex *) c1 : (Complex *) c2;
-(Complex *) rmult: (Complex *) c withReal: (double) r;

-(Complex *) div: (Complex *) num : (Complex *) den;

-(Complex *) pow: (Complex *) c exp: (double) p;

 
@end
