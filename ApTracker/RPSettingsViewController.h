//
//  RPSettingsViewController.h
//  ApTracker
//
//  Created by Ryan Popa on 8/31/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <UIKit/UIKit.h>

//Keys for NSUserDefaults dictionary
extern NSString * const kRPSettingsNickKey;
extern NSString * const kRPSettingsHostKey;
extern NSString * const kRPSettingsPortKey;

@interface RPSettingsViewController : UIViewController <UITextFieldDelegate>

@end
