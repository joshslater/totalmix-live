//
//  SettingsViewController.h
//  ReaperLive
//
//  Created by Josh Slater on 8/27/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSCSettingsDelegateProtocol <NSObject>
- (void)updateOscIpAddress:(NSString *)ipAddress inPort:(NSNumber *)inPort outPort:(NSNumber *)outPort;
- (void)sendTestOscMsg;
@end

@interface SettingsViewController : QuickDialogController <QuickDialogEntryElementDelegate,QuickDialogStyleProvider>
{
    QEntryElement *oscIpAddressElement;
    QEntryElement *oscInPortElement;
    QEntryElement *oscOutPortElement;
}

@property (weak, nonatomic) id <OSCSettingsDelegateProtocol> oscSettingsDelegate;

@end
