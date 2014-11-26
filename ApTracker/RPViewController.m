//
//  RPViewController.m
//  ApTracker
//
//  Created by Ryan Popa on 8/6/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "NSError+AlertHelper.h"
#import "RPSettingsViewController.h"
#import "RPStats.h"
#import "RPTrackingManager.h"
#import "RPViewController.h"
#import "RPViewVisibibiltyController.h"
#import "UIView+AnimationHelper.h"

@interface RPViewController ()
//Outlets
@property (weak, nonatomic) IBOutlet UILabel *totalApLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentApTimeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *trackButton;
@property (strong, nonatomic) IBOutlet RPViewVisibibiltyController *currentApTimeVisibilityController;
@property (strong, nonatomic) IBOutlet RPViewVisibibiltyController *refreshActivityIndicatorVisibilityController;
@property (strong, nonatomic) IBOutlet RPStopwatchTimer *currentApTimer;

@end

@implementation RPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Attempt to get user stats
    [[RPTrackingManager sharedInstance] getStatsWithCallback: @selector(getStatsCallbackSuccess:withError:) sender: self];
}

#pragma mark - Callbacks
//Callback for stats
//Populates the labels with AP stats
- (void)getStatsCallbackSuccess: (RPStats *)statsObject withError: (NSError *)error
{
    //If there was an error show message
    if (error)
    {
        [error showAlert];
        [self.loadingActivityIndicator fadeOut];
        return;
    }
    
    //Populate the labels with the user's AP stats
    self.totalApLabel.text = [statsObject.totalCount stringValue];
    
    //Populate the total time label
    NSTimeInterval totalTimeInterval = [statsObject.totalTime doubleValue];
    NSString *totalTimeString = [self timeStringInDaysFromTimeInterval: totalTimeInterval];
    self.totalTimeLabel.text = [NSString stringWithFormat: @"%@ days", totalTimeString];
    
    //If the user is currently drinking an ap start the current timer
    if (statsObject.isCurrentlyDrinking)
    {
        NSTimeInterval timeDrinkingCurrentAp = [statsObject.currentTime doubleValue];
        [self.currentApTimer startFromElapsedTime: timeDrinkingCurrentAp];
    }
    else
        [self.currentApTimer stop];
    
    //Set the track button text
    [self.trackButton setTitle: statsObject.isCurrentlyDrinking ? @"Stop" : @"Start" forState: UIControlStateNormal];
    
    //Fade the activity spinner out and replace it with the stats labels
    self.currentApTimeVisibilityController.shouldShowView = statsObject.isCurrentlyDrinking;
    [self.refreshActivityIndicatorVisibilityController hideView];
}

#pragma mark - Timer Delegate Methods
//Gets called every second when the drink timer is active
//Updates the now drinking label
- (void)stopwatchTimer: (RPStopwatchTimer *)timer hasHadTimeElapse: (NSTimeInterval)timeElapsed
{
    self.currentApTimeLabel.text = [self timeStringInHoursFromTimeInterval: timeElapsed];
}

#pragma mark - Actions
//Action for pressing the settings button
//Pops the view stack bringing the user to settings
- (IBAction)settingsAction: (UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

//Action for pressing the start/stop tracking button
//Makes start/stop request
- (IBAction)trackingStartStopAction: (UIButton *)sender
{
    //Start the refresh spinner
    [self.refreshActivityIndicatorVisibilityController showView];
    
    //Stop tracking the AP
    if ([sender.titleLabel.text isEqualToString: @"Stop"])
        [[RPTrackingManager sharedInstance] stopApWithCallback: @selector(getStatsCallbackSuccess:withError:) sender: self];
    
    //Start trackin an AP
    else
        [[RPTrackingManager sharedInstance] startApWithCallback: @selector(getStatsCallbackSuccess:withError:) sender: self];
}

#pragma mark - Helpers
//A time string in the format days:hours:mins from a timeinterval in seconds
- (NSString *)timeStringInDaysFromTimeInterval: (NSTimeInterval)timeInterval
{
    //Get individual time values
    int days = timeInterval / 86400;
    int hours = fmod(timeInterval, 86400) / 3600;
    int mins = fmod(timeInterval, 3600) / 60;
    
    //Create formated string
    return [NSString stringWithFormat: @"%02d:%02d:%02d", days, hours, mins];
}

//A time string in the format hours:mins:secs from a timeinterval in seconds
- (NSString *)timeStringInHoursFromTimeInterval: (NSTimeInterval)timeInterval
{
    int hours = timeInterval / 3600;
    int mins = fmod(timeInterval, 3600) / 60;
    int secs = fmod(timeInterval, 60);
    return [NSString stringWithFormat: @"%02d:%02d:%02d", hours, mins, secs];
}

@end
