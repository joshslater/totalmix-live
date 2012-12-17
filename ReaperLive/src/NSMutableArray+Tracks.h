//
//  NSMutableArray+Tracks.h
//  TotalMixLive
//
//  Created by Josh Slater on 12/16/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Tracks)
- (int)getBankStartForRow:(int)rowNum forTrackName:(NSString *)trackName;
- (void)removeDuplicateEntries;
@end
