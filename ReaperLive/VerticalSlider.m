//
//  VerticalSlider.m
//  ReaperLive
//
//  Created by Josh Slater on 8/8/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "VerticalSlider.h"

@implementation VerticalSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setRotatedThumbImage:(UIImage *)thumbImage 
{
    [self setThumbImage:[self rotateImage:thumbImage] forState:UIControlStateNormal];
    
}
               
- (void)setRotatedMinTrackImage:(UIImage *)minTrackImage 
{
    [self setMinimumTrackImage:[self rotateImage:minTrackImage] forState:UIControlStateNormal];
}

- (void)setRotatedMaxTrackImage:(UIImage *)maxTrackImage
{         
    // set the min and max trackImage

    [self setMaximumTrackImage:[self rotateImage:maxTrackImage] forState:UIControlStateNormal];

}

- (UIImage *)rotateImage:(UIImage *)image
{
    
    // rotate the fader cap
    CGSize s = {image.size.height,image.size.width};
 
    UIGraphicsBeginImageContextWithOptions(s, NO, 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(ctx, -M_PI_2);
    CGContextTranslateCTM(ctx,-image.size.width,0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0,0,image.size.width, image.size.height),
                       image.CGImage);
  
    UIImage *imageRotated = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageRotated;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
