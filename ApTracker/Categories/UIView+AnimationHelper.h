//
//  UIView+AnimationHelper.h
//  ApTracker
//
//  Created by Ryan Popa on 8/7/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AnimationHelper)

//Fade a view out to being invisible
- (void)fadeOut;

//Fade a view in to 100% alpha
- (void)fadeIn;

//Fade a view out to being invisible and then do something when done
- (void)fadeOutWithCompletion: (void (^)(BOOL finished))completion;

@end
