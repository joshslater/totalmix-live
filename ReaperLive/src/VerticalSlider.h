//
//  VerticalSlider.h
//  ReaperLive
//
//  Created by Josh Slater on 8/8/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalSlider : UISlider

- (void)setRotatedThumbImage:(UIImage *)thumbImage;
- (void)setRotatedMinTrackImage:(UIImage *)minTrackImage;
- (void)setRotatedMaxTrackImage:(UIImage *)maxTrackImage;

@end
