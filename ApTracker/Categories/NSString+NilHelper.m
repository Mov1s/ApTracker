//
//  NSString+isNilOrEmpty.m
//  Collect
//
//  Created by Ryan Popa on 7/8/13.
//  Copyright (c) 2013 Ryan Popa. All rights reserved.
//

#import "NSString+NilHelper.h"

@implementation NSString (NilHelper)

//Ensures a string has a non-empty value
+ (BOOL)stringIsNilOrEmpty: (NSString *)aString
{
    aString = [aString stringByReplacingOccurrencesOfString: @" " withString: @""];
    return !(aString && aString.length);
}

@end
