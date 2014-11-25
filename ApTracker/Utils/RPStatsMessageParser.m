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
    RPStatsMessageIndexTotal,
    RPStatsMessageIndexTotalTimeDays,
    RPStatsMessageIndexTotalTimeHours,
    RPStatsMessageIndexTotalTimeMins,
    RPStatsMessageIndexTotalTimeSecs,
    RPStatsMessageIndexCurrentTimeHours,
    RPStatsMessageIndexCurrentTimeMins,
    RPStatsMessageIndexCurrentTimeSecs
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
    NSError *error;
    
    //Create a regex for parsing the numbers out of a message
    self.regex = [NSRegularExpression regularExpressionWithPattern: @"[1234567890]+" options: NSRegularExpressionCaseInsensitive error: &error];
    if (error) return error;
    
    //Find all number ranges in the message
    NSArray *regexMatches = [self.regex matchesInString: self.message options: NSMatchingReportCompletion range: NSMakeRange(0, [self.message length])];
    NSArray *numberRanges = [regexMatches valueForKey: @"range"];
    if (numberRanges.count != 5 && numberRanges.count != 9) return [NSError errorWithDomain: @"com.rp.errors" code: 0 userInfo: nil];
    self.messageNumberRanges = numberRanges;
    
    //Write the parsed values
    _totalNumberOfAps = [self numberForMessageRangeIndex: RPStatsMessageIndexTotal];
    _totalApTimeDays = [self numberForMessageRangeIndex: RPStatsMessageIndexTotalTimeDays];
    _totalApTimeHours = [self numberForMessageRangeIndex: RPStatsMessageIndexTotalTimeHours];
    _totalApTimeMins = [self numberForMessageRangeIndex: RPStatsMessageIndexTotalTimeMins];
    _totalApTimeSecs = [self numberForMessageRangeIndex: RPStatsMessageIndexTotalTimeSecs];
    
    //Write the current AP time values if there are any
    if (self.messageNumberRanges.count > 5)
    {
        _currentApTimeHours = [self numberForMessageRangeIndex: RPStatsMessageIndexCurrentTimeHours];
        _currentApTimeMins = [self numberForMessageRangeIndex: RPStatsMessageIndexCurrentTimeMins];
        _currentApTimeSecs = [self numberForMessageRangeIndex: RPStatsMessageIndexCurrentTimeSecs];
    }
    
    return error;
}

#pragma mark - Helpers
//Gets a number from the message for a message number range index
- (NSNumber *)numberForMessageRangeIndex: (RPStatsMessageIndex)index
{
    NSString *messageSubstring = [self.message substringWithRange: [self.messageNumberRanges[index] rangeValue]];
    return [self numberFromString: messageSubstring];
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
