//
//  PrefsViewController.m
//  Tickifier
//
//  Created by Ben Maslen on 19/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "PrefsViewController.h"


@implementation PrefsViewController

// tab support in textviews
- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
  NSString * selector = NSStringFromSelector(commandSelector);
  if ([selector isEqualToString:@"insertTab:"]) {
    [[tagsTextField window] makeFirstResponder:tagsTextField];
    return YES;
  }
  return NO;
}


@end
