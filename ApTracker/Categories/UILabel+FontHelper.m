//
//  UILabel+TCCustomFont.m
//  Connect
//
//  Created by Rob Timpone on 3/27/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//
//  https://gist.github.com/redent/7830234
//

#import "UILabel+FontHelper.h"

@implementation UILabel (TCCustomFont)

- (NSString *)fontName
{
    return self.font.fontName;
}

- (void)setFontName: (NSString *)fontName
{
    self.font = [UIFont fontWithName: fontName size: self.font.pointSize];
}

@end