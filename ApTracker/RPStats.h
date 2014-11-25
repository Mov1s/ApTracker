//
//  RPStats.h
//  ApTracker
//
//  Created by Ryan Popa on 11/25/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPStats : NSObject

/** The total ammount of time drinking APs in seconds */
@property (nonatomic, strong) NSNumber *totalTime;

/** The total number of APs consumed */
@property (nonatomic, strong) NSNumber *totalCount;

/** The ammount of time spent drinking the current AP in seconds
 If no AP is currently being drank this will be nil
 
 @see +[RPStats isCurrentlyDrinking]
 */
@property (nonatomic, strong) NSNumber *currentTime;

/** True if there is an AP currently being consumed */
@property (nonatomic) BOOL isCurrentlyDrinking;

#pragma mark - Constructors
/** Create stats from an IRC message
 
 Will parse a message and try to extract the individual stats, the parser is expecting a formated
 message that has been returned from RafiBot.
 
 If the message can not be parsed nil will be returned
 
 @param message The message to parse into stat information
 @return A stats object or nil if the message format is invalid
 */
+ (instancetype)statsFromMessasge: (NSString *)message;

@end
