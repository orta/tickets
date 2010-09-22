//
//  PrefsViewController.m
//  Tickifier
//
//  Created by Ben Maslen on 19/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "AppViewController.h"


@implementation AppViewController

-(void)awakeFromNib{
  NSView *themeFrame = [[mainWindow contentView] superview];
  NSRect containerRect = [themeFrame frame]; 
  NSRect accessoryViewRect = [accessoryView frame]; 
  NSRect newFrame = NSMakeRect(
                               containerRect.size.width - accessoryViewRect.size.width,  
                               containerRect.size.height - accessoryViewRect.size.height,
                               accessoryViewRect.size.width,
                               accessoryViewRect.size.height);
  [accessoryView setFrame:newFrame];
  [themeFrame addSubview:accessoryView];
  
}

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
