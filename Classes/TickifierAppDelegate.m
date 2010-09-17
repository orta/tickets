//
//  TickifierAppDelegate.m
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import "TickifierAppDelegate.h"

@implementation TickifierAppDelegate

@synthesize window, setupWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

  if([[NSUserDefaults standardUserDefaults] objectForKey:@"api_key"]){
    [window becomeKeyWindow];
    [window orderFrontRegardless];
  }else{
    [setupWindow becomeKeyWindow];
    [setupWindow orderFrontRegardless];
    [setupWindow center];
  }
}

- (void)dealloc {

  [window release];
    [super dealloc];
}

@end
