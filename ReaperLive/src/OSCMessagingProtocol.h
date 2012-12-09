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

typedef enum
{
	OSCIncrementTrack,
	OSCDecrementTrack
}
oscChangeTrackDirection_t;

@protocol OSCMessagingProtocol <NSObject>

@property (nonatomic, strong) NSMutableArray *rowTracks;

- (void)updateOscIpAddress:(NSString *)ipAddress inPort:(NSInteger)inPort outPort:(NSInteger)outPort;
- (void)sendTestOscMsg;


- (void)sendOscAction:(oscActions_t)action;
- (void)selectFX:(NSInteger)fxNumber;
- (void)sendCannedMsg;
- (void)eqValueDidChange:(NSInteger)trackNumber band:(NSInteger)band item:(eqItems_t)item value:(float)value;


- (void)setBankStart:(int)trackNumber;
- (void)setStartTrack:(int)trackNumber;
- (void)volumeFaderDidChange:(int)trackNumber toValue:(float)value;
- (void)setBusInput;
- (void)setBusPlayback;
- (void)setBusOutput;







//- (void)sendEntireState;


@end