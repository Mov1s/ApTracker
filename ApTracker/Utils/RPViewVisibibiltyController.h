//
//  RPViewVisibibiltyController.h
//  ApTracker
//
//  Created by Ryan Popa on 11/26/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPViewVisibibiltyController : NSObject

/** The view that we want to control visibility for */
@property (nonatomic, weak) IBOutlet UIView *view;

/** A view that should not be shown at the same time as the primary view */
@property (nonatomic, weak) IBOutlet UIView *mutuallyExclusiveView;

/** Toggle if the primary view should be shown or hidden
 Changing this value will result in the view fading in or out
 */
@property (nonatomic) BOOL shouldShowView;

/** Show the primary view
 This will result in the view fading in
 */
- (void)showView;

/** Hide the primary view
 This will result in the view fading out
 */
- (void)hideView;

@end
