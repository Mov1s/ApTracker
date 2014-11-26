//
//  NSError+AlertHelper.m
//  ApTracker
//
//  Created by Ryan Popa on 11/25/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "NSError+AlertHelper.h"

@implementation NSError (AlertHelper)

//Show a UIAlertView with the localized string of the error
- (void)showAlert
{
    NSString *errorMessage = self.userInfo[NSLocalizedDescriptionKey] ?: @"There was an error";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: errorMessage delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alert show];
}

@end
