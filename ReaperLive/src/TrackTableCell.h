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

@property (nonatomic, retain) IBOutlet UILabel *trackLabel;
@property (nonatomic, retain) IBOutlet UIButton *gateButton;
@property (nonatomic, retain) IBOutlet UIButton *compButton;
@property (nonatomic, retain) IBOutlet EqButton *eqButton;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) EqThumbView *eqThumbView;

@end
