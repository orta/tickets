//
//  TickifierAppDelegate.m
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import "TickifierAppDelegate.h"
#import "PTHotKeyCenter.h"

@implementation TickifierAppDelegate

@synthesize window, setupWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self toggleGlobalHotKey:self];
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"api_key"]){
    [window becomeKeyWindow];
    [window orderFrontRegardless];
  }else{
    [setupWindow becomeKeyWindow];
    [setupWindow orderFrontRegardless];
    [setupWindow center];
  }
}

- (IBAction)toggleGlobalHotKey:(id)sender {
	if (globalHotKey != nil) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: globalHotKey];
		globalHotKey = nil;
   }
    
	globalHotKey = [[PTHotKey alloc] initWithIdentifier:@"tickifier"
                                             keyCombo:[PTKeyCombo keyComboWithKeyCode:[shortcutRecorder keyCombo].code
                                           modifiers:[shortcutRecorder cocoaToCarbonFlags: [shortcutRecorder keyCombo].flags]]];
	[globalHotKey setTarget: self];
	[globalHotKey setAction: @selector(hitHotKey:)];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKey];
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
  [self toggleGlobalHotKey: aRecorder];
}

- (void)hitHotKey:(PTHotKey *)hotKey {
  if([window isKeyWindow]){
    [window orderOut:self];
  }else{
    [window makeKeyAndOrderFront:self];
  }
}


@end
