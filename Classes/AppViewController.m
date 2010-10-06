//
//  PrefsViewController.m
//  Tickifier
//
//  Created by Ben Maslen on 19/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "AppViewController.h"

@implementation AppViewController
@synthesize fullView;

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
  self.fullView = NO;
  [self toggleViewMode:self];
}

- (IBAction) toggleViewMode:(id)sender {
//  448 - 240
  
  if(self.fullView){
    
    NSRect newFrame = [mainWindow frame];
    newFrame.size.width = 448;
    [mainWindow setFrame:newFrame display:YES animate:YES];
    self.fullView = !self.fullView;

  }else{
    
    self.fullView = !self.fullView;    
    NSRect newFrame = [mainWindow frame];
    newFrame.size.width = 266;
    [mainWindow setFrame:newFrame display:YES animate:YES];
  }
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

- (IBAction) cycleInfoLabel:(id)sender{
  NSLog(@"send %@", sender);
}

@end
