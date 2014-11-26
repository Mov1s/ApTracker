//
//  RPStatsMessageParser.m
//  ApTracker
//
//  Created by Ryan Popa on 11/25/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPStatsMessageParser.h"

typedef NS_ENUM(NSInteger, RPStatsMessageIndex)
{
    RPStatsMessageTotalIndex,
    RPStatsMessageTotalTimeIndex,
    RPStatsMessageCurrentTimeIndex,
};

typedef NS_ENUM(NSInteger, RPStatsMessageTimeComponentIndex)
{
    RPStatsMessageTimeComponentIndexDays,
    RPStatsMessageTimeComponentIndexHours,
    RPStatsMessageTimeComponentIndexMins,
    RPStatsMessageTimeComponentIndexSecs,
};

@interface RPStatsMessageParser()

//The message this parser will be parsing
@property (nonatomic, strong) NSString *message;

//The regex to use while parsing this message
@property (nonatomic, strong) NSRegularExpression *regex;

//The ranges of number values in the message
@property (nonatomic, strong) NSArray *messageNumberRanges;

@end

@implementation RPStatsMessageParser

//Create a message parser for a message
+ (instancetype)statsMessageParserWithMessage: (NSString *)message
{
    RPStatsMessageParser *parser = [RPStatsMessageParser new];
    parser.message = message;
    return parser;
}

//Parse the message
- (NSError *)parse
{
    //If the message is for a brand new user initizalize all values to zero
    if ([self.message isEqualToString: @"Nothing to report"])
    {
        [self initWithZeros];
        return nil;
    }
    
    NSError *error;
    
    //Create a regex for parsing the numbers out of a message
    self.regex = [NSRegularExpression regularExpressionWithPattern: @"[1234567890:]+" options: NSRegularExpressionCaseInsensitive error: &error];
    if (error) return error;
    
    //Find all number ranges in the message
    NSArray *regexMatches = [self.regex matchesInString: self.message options: NSMatchingReportCompletion range: NSMakeRange(0, [self.message length])];
    NSArray *numberRanges = [regexMatches valueForKey: @"range"];
    if (numberRanges.count != 2 && numberRanges.count != 4) return [NSError errorWithDomain: @"com.rp.errors" code: 0 userInfo: nil];
    self.messageNumberRanges = numberRanges;
    
    //Write the parsed values
    _totalNumberOfAps = [self numberForTotalApStat];
    _totalApTimeDays = [self numberFromMessage: RPStatsMessageTotalTimeIndex timeStat: RPStatsMessageTimeComponentIndexDays];
    _totalApTimeHours = [self numberFromMessage: RPStatsMessageTotalTimeIndex timeStat: RPStatsMessageTimeComponentIndexHours];
    _totalApTimeMins = [self numberFromMessage: RPStatsMessageTotalTimeIndex timeStat: RPStatsMessageTimeComponentIndexMins];
    _totalApTimeSecs = [self numberFromMessage: RPStatsMessageTotalTimeIndex timeStat: RPStatsMessageTimeComponentIndexSecs];
    
    //Write the current AP time values if there are any
    if (self.messageNumberRanges.count >= 3)
    {
        _currentApTimeHours = [self numberFromMessage: RPStatsMessageCurrentTimeIndex timeStat: RPStatsMessageTimeComponentIndexHours];
        _currentApTimeMins = [self numberFromMessage: RPStatsMessageCurrentTimeIndex timeStat: RPStatsMessageTimeComponentIndexMins];
        _currentApTimeSecs = [self numberFromMessage: RPStatsMessageCurrentTimeIndex timeStat: RPStatsMessageTimeComponentIndexSecs];
    }
    
    return error;
}

//Initialize the parser with all zero values
- (void)initWithZeros
{
    _totalNumberOfAps = @0;
    _totalApTimeDays = @0;
    _totalApTimeHours = @0;
    _totalApTimeMins = @0;
    _totalApTimeSecs = @0;
}

#pragma mark - Helpers
//The number of total APs pulled from the parsed message
- (NSNumber *)numberForTotalApStat
{
    NSString *messageSubstring = [self.message substringWithRange: [self.messageNumberRanges[RPStatsMessageTotalIndex] rangeValue]];
    return [self numberFromString: messageSubstring];
}

//A number from one of the time components of the parsed message
- (NSNumber *)numberFromMessage: (RPStatsMessageIndex)messageIndex timeStat: (RPStatsMessageTimeComponentIndex)timeComponent
{
    NSString *messageSubstring = [self.message substringWithRange: [self.messageNumberRanges[messageIndex] rangeValue]];
    NSMutableArray *totalTimeComponents = [[messageSubstring componentsSeparatedByString: @":"] mutableCopy];
    if (totalTimeComponents.count == 3) [totalTimeComponents insertObject: @"0" atIndex: RPStatsMessageTimeComponentIndexDays];
    NSString *totalTimeStatString = totalTimeComponents[timeComponent];
    return [self numberFromString: totalTimeStatString];
}

//Converts a string into a number
- (NSNumber *)numberFromString: (NSString *)string
{
    //Create a static number formater
    static NSNumberFormatter *nf;
    if (!nf) nf = [NSNumberFormatter new];
    
    return [nf numberFromString: string];
}

@end
