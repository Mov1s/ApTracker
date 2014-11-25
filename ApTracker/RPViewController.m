//
//  RPViewController.m
//  ApTracker
//
//  Created by Ryan Popa on 8/6/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPSettingsViewController.h"
#import "RPTrackingManager.h"
#import "RPViewController.h"
#import "UIView+AnimationHelper.h"

@interface RPViewController ()
//Outlets
@property (weak, nonatomic) IBOutlet UILabel *totalApLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentApTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *statsContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *currentApTimeContainer;
@property (weak, nonatomic) IBOutlet UILabel *currentApNoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackButton;

//Properties
@property (strong, nonatomic) NSDate *apStartDate;
@property (strong, nonatomic) NSTimer *apDrinkTimer;
@end

@implementation RPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Attempt to get user stats
    [[RPTrackingManager sharedInstance] getStatsWithCallback: @selector(getStatsCallbackSuccess:withError:) sender: self];
    
    //Hide the back button
    self.navigationItem.hidesBackButton = YES;
    
    //Start the stats container hidden
    self.statsContainerView.alpha = 0.0;
    
    //Start the current AP time hidden
    self.currentApTimeContainer.alpha = 0.0;
}

#pragma mark - Callbacks
//Callback for stats
//Populates the labels with AP stats
- (void)getStatsCallbackSuccess: (id)statsDict withError: (NSError *)error
{
    //If there was no error update the stats labels
    if (!error)
    {
        //Populate the labels with the user's AP stats
        self.totalApLabel.text = [statsDict[kRPStatsResponseTotalKey] stringValue];
        
        //Populate the total time label
        NSString *totalTimeString = [self timeStringInDaysFromTimeInterval: 4560];
        self.totalTimeLabel.text = [NSString stringWithFormat: @"%@ days", totalTimeString];

        //If the user is currently drinking an ap start the current timer
        if ([statsDict[kRPStatsResponseIsDrinkingKey] boolValue])
        {
            NSDate *apStartTime = [self apTimerStartDateFromHours: statsDict[kRPStatsResponseCurrentHoursKey]
                                                          minutes: statsDict[kRPStatsResponseCurrentlMinKey]
                                                          seconds: statsDict[kRPStatsResponseCurrentSecKey]];
            [self startApTimerWithStartDate: apStartTime];
            
            //Fade out the message and fade in the current AP time
            [self.currentApNoneLabel fadeOutWithCompletion:^(BOOL finished) {
                [self.currentApTimeContainer fadeIn];
            }];
        }
        else
        {
            //Fade out the current time and fade in the no ap message
            [self.currentApTimeContainer fadeOutWithCompletion:^(BOOL finished) {
                [self.currentApNoneLabel fadeIn];
            }];
        }
        
        //Fade the activity spinner out and replace it with the stats labels
        [self.loadingActivityIndicator fadeOutWithCompletion: ^(BOOL finished) {
            [self.statsContainerView fadeIn];
        }];
    }
    
    //If there was an error show message
    else
    {
        [self displayAlertFromError: error];
        [self.loadingActivityIndicator fadeOut];
    }
}

#pragma mark - Actions
//Action for pressing the settings button
//Pops the view stack bringing the user to settings
- (IBAction)settingsAction: (UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Timer Helpers
//Create a date representing the time an AP was started based on how long it has been in progress
//Pass in the hours, minutes and seconds that it has been in progress and it calculates when it began
- (NSDate *)apTimerStartDateFromHours: (NSNumber *)hours minutes: (NSNumber *)minutes seconds: (NSNumber *)seconds
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components: NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate: [NSDate date]];
    components.hour -= [hours integerValue];
    components.minute -= [minutes integerValue];
    components.second -= [seconds integerValue];
    return [cal dateFromComponents: components];
}

//Starts a timer to keep track of current run time of an AP
- (void)startApTimerWithStartDate: (NSDate *)startDate
{
    //Save start date
    self.apStartDate = startDate;
    
    //Start the timer
    self.apDrinkTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(timerCallback:) userInfo: nil repeats: YES];
}

//Gets called every second when the drink timer is active
//Updates the now drinking label
- (void)timerCallback: (NSTimer *)timer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate: self.apStartDate];
    self.currentApTimeLabel.text = [self timeStringInHoursFromTimeInterval: interval];
}

#pragma mark - Helpers

- (NSString *)timeStringInDaysFromTimeInterval: (NSTimeInterval)timeInterval
{
    int days = timeInterval / 86400;
    int hours = fmod(timeInterval, 86400) / 3600;
    int mins = fmod(timeInterval, 3600) / 60;
    return [NSString stringWithFormat: @"%02d:%02d:%02d", days, hours, mins];
}

- (NSString *)timeStringInHoursFromTimeInterval: (NSTimeInterval)timeInterval
{
    int hours = timeInterval / 3600;
    int mins = fmod(timeInterval, 3600) / 60;
    int secs = fmod(timeInterval, 60);
    return [NSString stringWithFormat: @"%02d:%02d:%02d", hours, mins, secs];
}

//Shows an error message alert
- (void)displayAlertFromError: (NSError *)error
{
    NSString *errorMessage = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message: errorMessage delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alert show];
}

@end
