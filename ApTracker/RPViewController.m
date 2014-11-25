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
@property (weak, nonatomic) IBOutlet UIButton *trackButton;
@property (weak, nonatomic) IBOutlet UIView *totalCountContainer;

//Constraint Outlets
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalCountTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *totalHeightConstraint;

//Properties
@property (strong, nonatomic) NSDate *apStartDate;
@property (strong, nonatomic) NSTimer *apDrinkTimer;
@end

@implementation RPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Style the track button
    self.trackButton.titleLabel.font = [UIFont fontWithName: @"Open Sans Regular" size: 42];
    self.trackButton.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.trackButton.layer.borderWidth = 2.0;
    self.trackButton.layer.cornerRadius = 7.0;
    
    //Attempt to get user stats
    [[RPTrackingManager sharedInstance] getStatsWithCallback: @selector(getStatsCallbackSuccess:withError:) sender: self];
    
    //Hide the back button
    self.navigationItem.hidesBackButton = YES;
    
    //Start the stats container hidden
    self.statsContainerView.alpha = 0.0;
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
        self.totalTimeLabel.attributedText = [self formatedTimeStringFromDays: statsDict[kRPStatsResponseTotalDaysKey]
                                                                        hours: statsDict[kRPStatsResponseTotalHoursKey]
                                                                      minutes: statsDict[kRPStatsResponseTotalMinKey]];

        //If the user is currently drinking an ap start the current timer
        if ([statsDict[kRPStatsResponseIsDrinkingKey] boolValue])
        {
            NSDate *apStartTime = [self apTimerStartDateFromHours: statsDict[kRPStatsResponseCurrentHoursKey]
                                                          minutes: statsDict[kRPStatsResponseCurrentlMinKey]
                                                          seconds: statsDict[kRPStatsResponseCurrentSecKey]];
            [self startApTimerWithStartDate: apStartTime];
        }
        
        //Fade the activity spinner out and replace it with the stats labels
        [self.loadingActivityIndicator fadeOutWithCompletion: ^(BOOL finished) {
            [self.statsContainerView fadeIn];
        }];
        
//        [self.view layoutIfNeeded];
//        [UIView animateWithDuration: 13 animations:^{
//            self.statsContainerTopConstraint.constant -= 128;
//            self.statsContainerBottomConstraint.constant += 128;
//            [self.view layoutIfNeeded];
//        }];
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
    NSLog(@"%f", interval);
}

#pragma mark - Helpers
//Formats days, hours, mins into an NSAttributed string
- (NSAttributedString *)formatedTimeStringFromDays: (NSNumber *)days hours: (NSNumber *)hours minutes: (NSNumber *)minutes
{
    //Construct the formated time string
    NSString *timeString = [NSString stringWithFormat: @"%@ days %@ hours %@ min", days, hours, minutes];
    
    //Adjust the starting point and length of the values in the string depending on the length of the individual parts
    int daysLength = [[days stringValue] length];
    int hoursStart = 6 + daysLength;
    int hoursLength = [[hours stringValue] length];
    int minStart = 13 + daysLength + hoursLength;
    int minLength = [[minutes stringValue] length];
    
    //Make the numbers large than the other text
    NSMutableAttributedString *attributedTimeString = [[NSMutableAttributedString alloc] initWithString: timeString];
    [attributedTimeString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 42.0] range: NSMakeRange(0, daysLength)];
    [attributedTimeString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 42.0] range: NSMakeRange(hoursStart, hoursLength)];
    [attributedTimeString addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize: 42.0] range: NSMakeRange(minStart, minLength)];
    
    return attributedTimeString;
}

//Shows an error message alert
- (void)displayAlertFromError: (NSError *)error
{
    NSString *errorMessage = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message: errorMessage delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alert show];
}

@end
