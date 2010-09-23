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
  fullView = NO;
}

- (IBAction) toggleViewMode:(id)sender {
//  448 - 240
  
  if(fullView){
    NSRect newFrame = [mainWindow frame];
    newFrame.size.width = 448;
    [mainWindow setFrame:newFrame display:YES animate:YES];
  }else{
    NSRect newFrame = [mainWindow frame];
    newFrame.size.width = 266;
    [mainWindow setFrame:newFrame display:YES animate:YES];
  }
  fullView = !fullView;
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
