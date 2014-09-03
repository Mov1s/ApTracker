//
//  RPSettingsViewController.m
//  ApTracker
//
//  Created by Ryan Popa on 8/31/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "NSString+NilHelper.h"
#import "RPSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

//Keys for NSUserDefaults dictionary
NSString * const kRPSettingsNickKey = @"kRPSettingsNickKey";
NSString * const kRPSettingsHostKey = @"kRPSettingsHostKey";
NSString * const kRPSettingsPortKey = @"kRPSettingsPortKey";

@interface RPSettingsViewController ()
//Outlets
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation RPSettingsViewController

- (void)viewDidLoad
{
    //Style the save button
    self.saveButton.titleLabel.font = [UIFont fontWithName: @"Open Sans Regular" size: 42];
    self.saveButton.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.saveButton.layer.borderWidth = 2.0;
    self.saveButton.layer.cornerRadius = 7.0;
    
    //Restore any saved settings to the text fields
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nickTextField.text = [defaults objectForKey: kRPSettingsNickKey];
    self.hostTextField.text = [defaults objectForKey: kRPSettingsHostKey];
    self.portTextField.text = [defaults objectForKey: kRPSettingsPortKey];
    
    //Continue straight to the stats if settings have already been configured
    if ([self settingsBoxesHaveValues])
    {
        [self performSegueWithIdentifier: @"statsSegue" sender: self];
        [self.saveButton setTitle: @"Save" forState: UIControlStateNormal];
        return;
    }
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

#pragma mark - Actions
//Action for the save button
//Validates the settings and continues to the stats
- (IBAction)saveAction: (UIButton *)sender
{
    //Continue if things are valid
    if ([self settingsBoxesHaveValues])
    {
        //Save settings
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: self.nickTextField.text forKey: kRPSettingsNickKey];
        [defaults setObject: self.hostTextField.text forKey: kRPSettingsHostKey];
        [defaults setObject: self.portTextField.text forKey: kRPSettingsPortKey];
        [defaults synchronize];

        //Move to the stats screen
        [self performSegueWithIdentifier: @"statsSegue" sender: self];
    }
    
    //Show message otherwise
    else
        [self displayAlert: @"All settings are required."];
}

#pragma mark - Helpers
//Checks that all boxes have a value
- (BOOL)settingsBoxesHaveValues
{
    BOOL hostValue = ![NSString stringIsNilOrEmpty: self.hostTextField.text];
    BOOL portValue = ![NSString stringIsNilOrEmpty: self.portTextField.text];
    BOOL nickValue = ![NSString stringIsNilOrEmpty: self.nickTextField.text];
    return hostValue && portValue && nickValue;
}

//Shows a message
- (void)displayAlert: (NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message: message delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alert show];
}

@end
