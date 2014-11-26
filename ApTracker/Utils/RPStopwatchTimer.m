//
//  RPStopwatchTimer.m
//  ApTracker
//
//  Created by Ryan Popa on 11/26/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPStopwatchTimer.h"

@interface RPStopwatchTimer()

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RPStopwatchTimer

//Start the stopwatch with an elapsed time seed
- (void)startFromElapsedTime: (NSTimeInterval)timeElapsed
{
    //Calculate and save the start date of the timer based on how much time has elapsed
    self.startDate = [NSDate dateWithTimeIntervalSinceNow: -timeElapsed];;
    
    //Start the timer to update every second
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(timerCallback:) userInfo: nil repeats: YES];
    [self.timer fire];
}

//Start the stopwatch
- (void)start
{
    [self startFromElapsedTime: 0];
}

//Stops the currently running timer
- (void)stop
{
    self.timer = nil;
}

//Gets called every second when the timer is active
//Updates the delegate of timer progress
- (void)timerCallback: (NSTimer *)timer
{
    NSTimeInterval interval = -[self.startDate timeIntervalSinceNow];
    [self.delegate stopwatchTimer: self hasHadTimeElapse: interval];
}

@end
