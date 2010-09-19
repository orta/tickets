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

//- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo
//{
//	if (aRecorder == shortcutRecorder)
//   {
//		[self toggleGlobalHotKey: aRecorder];
//   }
//}
//
//- (void)hitHotKey:(PTHotKey *)hotKey
//{
//	NSMutableAttributedString *logString = [globalHotKeyLogView textStorage];
//	[[logString mutableString] appendString: [NSString stringWithFormat: @"%@ pressed. \n", [shortcutRecorder keyComboString]]];
//	
//	[globalHotKeyLogView scrollPoint: NSMakePoint(0, [globalHotKeyLogView frame].size.height)];
//}


@end
