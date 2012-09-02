//
//  TrackTableCell.h
//  ReaperLive Remote
//
//  Created by Josh Slater on 7/18/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EqThumbView;
@class EqButton;

@interface TrackTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *trackLabel;
@property (nonatomic, weak) IBOutlet UIButton *gateButton;
@property (nonatomic, weak) IBOutlet UIButton *compButton;
@property (nonatomic, weak) IBOutlet EqButton *eqButton;
@property (nonatomic, retain) UISlider *volumeSlider;
@property (nonatomic, retain) UISlider *vuMeter;
@property (nonatomic, retain) EqThumbView *eqThumbView;

@end
