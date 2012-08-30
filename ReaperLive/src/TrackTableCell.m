//
//  TrackTableCell.m
//  ReaperLive Remote
//
//  Created by Josh Slater on 7/18/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "TrackTableCell.h"

@implementation TrackTableCell

@synthesize trackLabel;
@synthesize eqButton;
@synthesize gateButton;
@synthesize compButton;
@synthesize volumeSlider;
@synthesize eqThumbView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
