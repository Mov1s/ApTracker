//
//  RPTrackingManager.h
//  ApTracker
//
//  Created by Ryan Popa on 8/7/14.
//  Copyright (c) 2014 Ryan Popa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPTrackingManager : NSObject

/** Returns a shared instance of the manager for use as a singleton */
+ (RPTrackingManager *)sharedInstance;

/** Get AP stats */
- (void)getStatsWithCallback: (SEL)callback sender: (id)sender;

@end
