//
//  UIView+AnimationHelper.m
//  ApTracker
//
//  Created by Ryan Popa on 8/7/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import "UIView+AnimationHelper.h"

@implementation UIView (AnimationHelper)

//Fade a view out to being invisible
- (void)fadeOut
{
    [UIView animateWithDuration: 0.3 animations: ^{ self.alpha = 0.0; }];
}

//Fade a view in to 100% alpha
- (void)fadeIn
{
    [UIView animateWithDuration: 0.3 animations: ^{ self.alpha = 1.0; }];
}

//Fade a view out to being invisible and then do something when done
- (void)fadeOutWithCompletion: (void (^)(BOOL finished))completion
{
    [UIView animateWithDuration: 0.3 animations: ^{ self.alpha = 0.0; } completion: completion];
}

@end
