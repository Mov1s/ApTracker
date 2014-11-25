//
//  RPTrackingManager.m
//  ApTracker
//
//  Created by Ryan Popa on 8/7/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPSettingsViewController.h"
#import "RPStats.h"
#import "RPTrackingManager.h"
#import <AFNetworking/AFNetworking.h>

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
                       
                        //Get the message from the API response containing the stats
                        NSString *message = responseObject[@"message"];
                        
                        //Parse the message into stats
                        RPStats *stats = [RPStats statsFromMessasge: message];
                        
                        //If there is no stats object then it has failed to be created, meaning there was a parse error
                        if (!stats)
                        {
                            NSError *error = [NSError errorWithDomain: @"com.rp.errors" code: 1 userInfo: @{ NSLocalizedDescriptionKey : @"There was an error parsing the API response." }];
                            [sender performSelector: callback withObject: nil withObject: error];
                        }
                        
                        //Everything was fine, return the stats object
                        else
                            [sender performSelector: callback withObject: stats withObject: nil];
                        
                    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                        [sender performSelector: callback withObject: nil withObject: error];
                    }];
}

@end
