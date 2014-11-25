//
//  RPStatsMessageParser.h
//  ApTracker
//
//  Created by Ryan Popa on 11/25/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPStatsMessageParser : NSObject

@property (nonatomic, strong, readonly) NSNumber *totalNumberOfAps;
@property (nonatomic, strong, readonly) NSNumber *totalApTimeDays;
@property (nonatomic, strong, readonly) NSNumber *totalApTimeHours;
@property (nonatomic, strong, readonly) NSNumber *totalApTimeMins;
@property (nonatomic, strong, readonly) NSNumber *totalApTimeSecs;
@property (nonatomic, strong, readonly) NSNumber *currentApTimeHours;
@property (nonatomic, strong, readonly) NSNumber *currentApTimeMins;
@property (nonatomic, strong, readonly) NSNumber *currentApTimeSecs;

/** Create a message parser for a message */
+ (instancetype)statsMessageParserWithMessage: (NSString *)message;

/** Parse the message
 
 After parsing is complete the parser's properties will be populated. If there was an error
 during parse all the parser's properties will be nil.
 
 @return An error if there was a problem parsing, or nil if everything went fine
 */
- (NSError *)parse;

@end
