//
//  RPSettingsViewController.m
//  ApTracker
//
//  Created by Ryan Popa on 8/31/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPSettingsViewController.h"

//Keys for NSUserDefaults dictionary
NSString * const kRPSettingsNickKey = @"kRPSettingsNickKey";
NSString * const kRPSettingsHostKey = @"kRPSettingsHostKey";
NSString * const kRPSettingsPortKey = @"kRPSettingsPortKey";

@interface RPSettingsViewController ()
//Outlets
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@end

@implementation RPSettingsViewController

- (void)viewDidLoad
{
    //Restore any saved settings to the text fields
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nickTextField.text = [defaults objectForKey: kRPSettingsNickKey];
    self.hostTextField.text = [defaults objectForKey: kRPSettingsHostKey];
    self.portTextField.text = [defaults objectForKey: kRPSettingsPortKey];
}

- (void)viewWillDisappear: (BOOL)animated
{
    //Save settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: self.nickTextField.text forKey: kRPSettingsNickKey];
    [defaults setObject: self.hostTextField.text forKey: kRPSettingsHostKey];
    [defaults setObject: self.portTextField.text forKey: kRPSettingsPortKey];
    [defaults synchronize];
}

#pragma mark - TextField Delegate
//Triggered whenever return is pressed in a TextField
//Moves focus to the next TextField
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    //Move focus to host when pressing enter in nick
    if (textField == self.nickTextField)
        [self.hostTextField becomeFirstResponder];

    //Move focus to port when pressing enter in host
    else if (textField == self.hostTextField)
        [self.portTextField becomeFirstResponder];
    
    //Dismiss keyboard when pressing enter in port
    else if (textField == self.portTextField)
        [self.portTextField resignFirstResponder];
    
    return NO;
}

@end
