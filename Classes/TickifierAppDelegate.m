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
	if (globalHotKeyNewTicket != nil) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: globalHotKeyNewTicket];
		globalHotKeyNewTicket = nil;
   }
	globalHotKeyNewTicket = [[PTHotKey alloc] initWithIdentifier:@"tickifier"
                                             keyCombo:[PTKeyCombo keyComboWithKeyCode:[shortcutRecorderNewTicket keyCombo].code
                                           modifiers:[shortcutRecorderNewTicket cocoaToCarbonFlags: [shortcutRecorderNewTicket keyCombo].flags]]];
	[globalHotKeyNewTicket setTarget: self];
	[globalHotKeyNewTicket setAction: @selector(hitHotKey:)];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKeyNewTicket];
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
  [self toggleGlobalHotKey: aRecorder];
}

- (void)hitHotKey:(PTHotKey *)hotKey {
  if([window isKeyWindow]){
    [[NSApplication sharedApplication] hide:self];
    [window orderOut:self];
  }else{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [window makeKeyAndOrderFront:self];
  }
}


@end
