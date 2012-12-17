//
//  NSMutableArray+Tracks.m
//  TotalMixLive
//
//  Created by Josh Slater on 12/16/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "NSMutableArray+Tracks.h"
#import "Track.h"

@implementation NSMutableArray (Tracks)

- (int) getBankStartForRow:(int)rowNum forTrackName:(NSString *)trackName
{
#if 0
    NSLog(@"NSMutableArray+Tracks::getTrackNameForBankStart");
#endif
    
    NSMutableDictionary *rowTracks = [self objectAtIndex:rowNum];
    
    for(id key in rowTracks)
    {
        Track *track = [rowTracks objectForKey:key];
        
        if([track.name isEqualToString:trackName])
            return [key intValue];
    }
    
    // what should we really return if there was no track with that name?
    return -1;
}

- (void) removeDuplicateEntries
{
    NSMutableDictionary *tracks;
    NSString *trackName;
    NSString *innerTrackName;
    
    for(int bus = 0; bus < 3; bus++)
    {
        tracks = [self objectAtIndex:bus];
        
        NSArray *allKeys = [tracks allKeys];
        
        for(id key1 in allKeys)
        {
            trackName = ((Track *)[tracks objectForKey:key1]).name;
            
            for (id key2 in allKeys)
            {
                innerTrackName = ((Track *)[tracks objectForKey:key2]).name;
                
                if([key1 intValue] != [key2 intValue] && [trackName isEqualToString:innerTrackName])
                {
                    // found a match -- delete the higher key value
                    int maxKey = MAX([key1 intValue], [key2 intValue]);
                    
                    [tracks removeObjectForKey:[NSNumber numberWithInt:maxKey]];
                }
            }
        }
    }
}

@end
