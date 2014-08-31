//
//  RPTrackingManager.h
//  ApTracker
//
//  Created by Ryan Popa on 8/7/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <Foundation/Foundation.h>

//Keys for stats dictionary
extern NSString * const kRPStatsResponseTotalKey;
extern NSString * const kRPStatsResponseTotalDaysKey;
extern NSString * const kRPStatsResponseTotalHoursKey;
extern NSString * const kRPStatsResponseTotalMinKey;
extern NSString * const kRPStatsResponseIsDrinkingKey;
extern NSString * const kRPStatsResponseCurrentHoursKey;
extern NSString * const kRPStatsResponseCurrentlMinKey;
extern NSString * const kRPStatsResponseCurrentSecKey;

@interface RPTrackingManager : NSObject

/** Returns a shared instance of the manager for use as a singleton */
+ (RPTrackingManager *)sharedInstance;

/** Get AP stats */
- (void)getStatsWithCallback: (SEL)callback sender: (id)sender;

@end
