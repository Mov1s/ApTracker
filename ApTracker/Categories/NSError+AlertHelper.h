//
//  NSError+AlertHelper.h
//  ApTracker
//
//  Created by Ryan Popa on 11/25/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (AlertHelper)

/** Show a UIAlertView with the localized string of the error */
- (void)showAlert;

@end
