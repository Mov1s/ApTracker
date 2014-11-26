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

#pragma mark - Lifecycle Methods
- (instancetype)init
{
    self = [super init];
    
    //Observe background/foreground notifications to suspend the timer
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(resume) name: UIApplicationWillEnterForegroundNotification object: [UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(stop) name: UIApplicationDidEnterBackgroundNotification object: [UIApplication sharedApplication]];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Stopwatch Timer Control Methods
//Start the stopwatch with an elapsed time seed
- (void)startFromElapsedTime: (NSTimeInterval)timeElapsed
{
    //Calculate and save the start date of the timer based on how much time has elapsed
    self.startDate = [NSDate dateWithTimeIntervalSinceNow: -timeElapsed];;
    
    //Start the timer
    [self resume];
}

//Start the stopwatch
- (void)start
{
    [self startFromElapsedTime: 0];
}

//Stops the currently running timer
- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}

//Resumes the currently running timer
//If the timer has been suspened resuming it will start the delegate notifications but does not
//reset the timer, it will pick up from the original start time
- (void)resume
{
    //Start the timer to update every second
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(timerCallback:) userInfo: nil repeats: YES];
    [self.timer fire];
}

#pragma mark - Timer Callbacks
//Gets called every second when the timer is active
//Updates the delegate of timer progress
- (void)timerCallback: (NSTimer *)timer
{
    NSTimeInterval interval = -[self.startDate timeIntervalSinceNow];
    [self.delegate stopwatchTimer: self hasHadTimeElapse: interval];
}

@end
