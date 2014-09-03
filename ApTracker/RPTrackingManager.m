//
//  RPTrackingManager.m
//  ApTracker
//
//  Created by Ryan Popa on 8/7/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPSettingsViewController.h"
#import "RPTrackingManager.h"
#import <AFNetworking/AFNetworking.h>

//Keys for stats dictionary
NSString * const kRPStatsResponseTotalKey = @"kRPStatsResponseTotalKey";
NSString * const kRPStatsResponseTotalDaysKey = @"kRPStatsResponseDaysKey";
NSString * const kRPStatsResponseTotalHoursKey = @"kRPStatsResponseHoursKey";
NSString * const kRPStatsResponseTotalMinKey = @"kRPStatsResponseMinKey";
NSString * const kRPStatsResponseIsDrinkingKey = @"kRPStatsResponseIsDrinkingKey";
NSString * const kRPStatsResponseCurrentHoursKey = @"kRPStatsResponseCurrentHoursKey";
NSString * const kRPStatsResponseCurrentlMinKey = @"kRPStatsResponseCurrentlMinKey";
NSString * const kRPStatsResponseCurrentSecKey = @"kRPStatsResponseCurrentSecKey";

static RPTrackingManager *trackingManagerSharedInstance = nil;

@interface RPTrackingManager()
@property (nonatomic, strong) AFHTTPRequestOperationManager *sharedManager;
@end

@implementation RPTrackingManager

//Returns a shared instance of the manager for use as a singleton
+ (RPTrackingManager *)sharedInstance
{
    if (!trackingManagerSharedInstance)
    {
        trackingManagerSharedInstance = [RPTrackingManager new];
        trackingManagerSharedInstance.sharedManager = [self setupNewManager];
    }
    
    return trackingManagerSharedInstance;
}

//Create and configure a new AFNetworking request manager
+ (AFHTTPRequestOperationManager *)setupNewManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    
    //Allow text/html content type
    NSSet *contentTypes = manager.responseSerializer.acceptableContentTypes;
    manager.responseSerializer.acceptableContentTypes = [contentTypes setByAddingObject: @"text/html"];
    
    return manager;
}

#pragma mark - API Requests
//Get AP stats
- (void)getStatsWithCallback: (SEL)callback sender: (id)sender;
{
    //Construct URI
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *baseUrl = [defaults objectForKey: kRPSettingsHostKey];
    NSString *port = [defaults objectForKey: kRPSettingsPortKey];
    NSString *user = [defaults objectForKey: kRPSettingsNickKey];
    NSString *path = [NSString stringWithFormat: @"%@:%@/%@/%@", baseUrl, port, @"stats", user];
    
    //Request
    [self.sharedManager GET: path
                 parameters: nil
                    success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                        @try
                        {
                            //Get the message from the API response containing the stats
                            NSString *message = responseObject[@"message"];
                            
                            //Find all numbers in the message
                            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"[123456789]+" options: NSRegularExpressionCaseInsensitive error: nil];
                            NSArray *numbers = [regex matchesInString: message options: NSMatchingReportCompletion range: NSMakeRange(0, [message length])];
                            
                            //Determine if the current user is currently drinking an AP
                            BOOL isCurrentlyDrinking = numbers.count > 5;
                            
                            //Create a dictionary that has all the stat numbers in it
                            NSMutableDictionary *response = [self statsDictionaryForMessage: message usingNumberRanges: numbers];
                            
                            //If the user is drinking an ap include stats around that
                            if (isCurrentlyDrinking)
                            {
                                NSMutableDictionary *currentStats = [self currentApDictionaryForMessage: message usingNumberRanges: numbers];
                                [response addEntriesFromDictionary: currentStats];
                            }
                            
                            //Add the currently drinking status to the response
                            [response setObject: [NSNumber numberWithBool: isCurrentlyDrinking] forKey: kRPStatsResponseIsDrinkingKey];
                            
                            [sender performSelector: callback withObject: response withObject: nil];
                        }
                        @catch (NSException *exception)
                        {
                            NSError *error = [NSError errorWithDomain: @"com.rp.errors" code: 1 userInfo: @{ NSLocalizedDescriptionKey : @"There was an error parsing the API response." }];
                            [sender performSelector: callback withObject: nil withObject: error];
                        }
                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                        [sender performSelector: callback withObject: nil withObject: error];
                    }];
}

#pragma mark - Response Dictionaries
- (NSMutableDictionary *)statsDictionaryForMessage: (NSString *)message usingNumberRanges: (NSArray *)numberRanges
{
    //Find the ranges of each invidual number
    NSRange totalRange = [numberRanges[0] range];
    NSRange dayRange = [numberRanges[1] range];
    NSRange hourRange = [numberRanges[2] range];
    NSRange minRange = [numberRanges[3] range];
    
    //Use the ranges to pull out each number
    NSString *totalAps = [message substringWithRange: totalRange];
    NSString *days = [message substringWithRange: dayRange];
    NSString *hours = [message substringWithRange: hourRange];
    NSString *min = [message substringWithRange: minRange];
    
    //Create the response dictionary
    return [NSMutableDictionary dictionaryWithDictionary: @{ kRPStatsResponseTotalKey : [self numberFromString: totalAps],
                                                             kRPStatsResponseTotalDaysKey : [self numberFromString: days],
                                                             kRPStatsResponseTotalHoursKey : [self numberFromString: hours],
                                                             kRPStatsResponseTotalMinKey : [self numberFromString: min] }];
}

- (NSMutableDictionary *)currentApDictionaryForMessage: (NSString *)message usingNumberRanges: (NSArray *)numberRanges
{
    //Find the ranges of each invidual number
    NSRange hourRange = [numberRanges[5] range];
    NSRange minRange = [numberRanges[6] range];
    NSRange secRange = [numberRanges[7] range];
    
    //Use the ranges to pull out each number
    NSString *hours = [message substringWithRange: hourRange];
    NSString *min = [message substringWithRange: minRange];
    NSString *sec = [message substringWithRange: secRange];

    //Create the response dictionary
    return [NSMutableDictionary dictionaryWithDictionary: @{ kRPStatsResponseCurrentHoursKey : [self numberFromString: hours],
                                                             kRPStatsResponseCurrentlMinKey : [self numberFromString: min],
                                                             kRPStatsResponseCurrentSecKey : [self numberFromString: sec] }];
}

#pragma mark - Helpers
//Converts a string into a number
- (NSNumber *)numberFromString: (NSString *)string
{
    //Create a static number formater
    static NSNumberFormatter *nf;
    if (!nf) nf = [NSNumberFormatter new];
    
    return [nf numberFromString: string];
}
@end
