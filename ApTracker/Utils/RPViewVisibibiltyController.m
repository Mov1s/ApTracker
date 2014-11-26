//
//  RPViewVisibibiltyController.m
//  ApTracker
//
//  Created by Ryan Popa on 11/26/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "RPViewVisibibiltyController.h"
#import "UIView+AnimationHelper.h"

@implementation RPViewVisibibiltyController

- (void)setShouldShowView: (BOOL)shouldShow
{
    _shouldShowView = shouldShow;
    
    //Determine which views to show and which to hide
    UIView *viewToShow = shouldShow ? self.view : self.mutuallyExclusiveView;
    UIView *viewToHide = shouldShow ? self.mutuallyExclusiveView : self.view;
    
    //Fade one view out and another in
    [viewToHide fadeOutWithCompletion: ^(BOOL finished) {
        [viewToShow fadeIn];
    }];
}

- (void)showView
{
    self.shouldShowView = YES;
}

- (void)hideView
{
    self.shouldShowView = NO;
}

@end
