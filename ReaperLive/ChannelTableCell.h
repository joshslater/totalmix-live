//
//  ChannelTableCell.h
//  ReaperLive Remote
//
//  Created by Josh Slater on 7/18/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *channelLabel;
@property (nonatomic, retain) IBOutlet UIButton *gateButton;
@property (nonatomic, retain) IBOutlet UIButton *compButton;
@property (nonatomic, retain) IBOutlet UIButton *eqButton;

@end
