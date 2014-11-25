//
//  RPStats.m
//  ApTracker
//
//  Created by Ryan Popa on 11/25/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPStats.h"
#import "RPStatsMessageParser.h"

@implementation RPStats

//Create stats from an IRC message
+ (instancetype)statsFromMessasge: (NSString *)message
{
    //Try to parse the message, return nil if parse failed
    RPStatsMessageParser *parser = [RPStatsMessageParser statsMessageParserWithMessage: message];
    NSError *error = [parser parse];
    if (error) return nil;
    
    //Create new stats object
    RPStats *stats = [RPStats new];
    
    //Populate stats values
    stats.totalCount = parser.totalNumberOfAps;
    stats.totalTime = [NSNumber numberWithLong: ([parser.totalApTimeDays longValue] * 86400) + ([parser.totalApTimeHours longValue] * 3600) + ([parser.totalApTimeMins longValue] * 60)];
    stats.isCurrentlyDrinking = parser.currentApTimeHours != nil;
    if (stats.isCurrentlyDrinking)
        stats.currentTime = [NSNumber numberWithLong: ([parser.currentApTimeHours longValue] * 3600) + ([parser.currentApTimeMins longValue] * 60) + [parser.currentApTimeSecs longValue]];
    
    return stats;
}

@end
