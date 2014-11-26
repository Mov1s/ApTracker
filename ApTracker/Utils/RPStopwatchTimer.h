//
//  RPStopwatchTimer.h
//  ApTracker
//
//  Created by Ryan Popa on 11/26/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RPStopwatchTimer;

/** Delegate protocol for classes that want to be alerted of the stopwatch's state */
@protocol RPStopwatchTimerDelegate <NSObject>

/** Called every second while the stopwatch is activley running
 Provides a status update on the current elapsed time
 
 @param timer The stopwatch timer that has had time elapse
 @param timeElapsed The total amount of time elapsed since this stopwatch was started
 */
- (void)stopwatchTimer: (RPStopwatchTimer *)timer hasHadTimeElapse: (NSTimeInterval)timeElapsed;

@end




/** Stopwatch class for keep track of elapsed seconds */
@interface RPStopwatchTimer : NSObject

/** Delegate to notify of changes to the elapsed time */
@property (nonatomic, weak) IBOutlet id <RPStopwatchTimerDelegate> delegate;



#pragma mark - Stopwatch Timer Control Methods
/** Start the stopwatch with an elapsed time seed
 This is the time elapsed that will be used as a starting point for the timer
 
 @param timeElapsed The amount of elapsed time that you would like the timer to start with
 */
- (void)startFromElapsedTime: (NSTimeInterval)timeElapsed;

/** Start the stopwatch */
- (void)start;

/** Stops the currently running timer */
- (void)stop;

@end
