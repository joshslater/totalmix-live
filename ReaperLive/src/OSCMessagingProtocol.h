//
//  OSCMessagingProtocol.h
//  ReaperLive
//
//  Created by Josh Slater on 9/4/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    EQItemGain,
    EQItemFrequency,
    EQItemQ    
} eqItems_t;

typedef enum
{
    OSCActionRefreshDevices
} oscActions_t;

@protocol OSCMessagingProtocol <NSObject>


- (void)setBankStart:(int)trackNumber;
- (void)volumeFaderDidChange:(int)trackNumber toValue:(float)value;
- (void)sendOscAction:(oscActions_t)action;
- (void)eqValueDidChange:(NSInteger)trackNumber band:(NSInteger)band item:(eqItems_t)item value:(float)value;
- (void)updateOscIpAddress:(NSString *)ipAddress inPort:(NSInteger)inPort outPort:(NSInteger)outPort;
- (void)sendTestOscMsg;
- (void)selectTrack:(NSInteger)trackNumber;
- (void)selectFX:(NSInteger)fxNumber;
- (void)sendCannedMsg;
//- (void)sendEntireState;


@end