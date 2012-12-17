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

// FIXME: I don't really think these properties should be in the protocol
@property (nonatomic, strong) NSMutableArray *tracks;
// keep track of the bank start value
@property (nonatomic) NSInteger bankStart;

- (void)updateOscIpAddress:(NSString *)ipAddress inPort:(NSInteger)inPort outPort:(NSInteger)outPort;
- (void)sendTestOscMsg;

- (void)initState;

- (void)sendCannedMsg;
- (void)eqValueDidChange:(NSInteger)trackNumber band:(NSInteger)band item:(eqItems_t)item value:(float)value;

- (void)setStartTrack:(int)trackNumber page:(int)pageNum;
- (void)sendSetBankStart:(int)bankStartValue;
- (void)volumeFaderDidChange:(int)visibleTrackNumber toValue:(float)value;
- (void)setBusInput:(int)pageNum;
- (void)setBusPlayback:(int)pageNum;
- (void)setBusOutput:(int)pageNum;
- (void)setPage:(int)pageNum;
- (void)trackPlusMinus:(oscChangeTrackDirection_t)direction page:(int)pageNum;






//- (void)sendEntireState;


@end