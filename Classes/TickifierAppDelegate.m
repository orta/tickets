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

@synthesize newTicketWindow, setupWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self toggleNewTicketHotKey:self];
  [self toggleListTicketsHotKey:self];

  if([[NSUserDefaults standardUserDefaults] objectForKey:@"api_key"]){
    [newTicketWindow becomeKeyWindow];
    [newTicketWindow orderFrontRegardless];
  }else{
    [setupWindow becomeKeyWindow];
    [setupWindow orderFrontRegardless];
    [setupWindow center];
  }
}

- (IBAction)toggleNewTicketHotKey:(id)sender {
	if (globalHotKeyNewTicket != nil) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: globalHotKeyNewTicket];
		globalHotKeyNewTicket = nil;
   }
	globalHotKeyNewTicket = [[PTHotKey alloc] initWithIdentifier:@"tickifier"
                                             keyCombo:[PTKeyCombo keyComboWithKeyCode:[shortcutRecorderNewTicket keyCombo].code
                                           modifiers:[shortcutRecorderNewTicket cocoaToCarbonFlags: [shortcutRecorderNewTicket keyCombo].flags]]];
	[globalHotKeyNewTicket setTarget: self];
	[globalHotKeyNewTicket setAction: @selector(hitNewTicketHotKey:)];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKeyNewTicket];
}

- (IBAction)toggleListTicketsHotKey:(id)sender{
  if (globalHotKeyNewTicket != nil) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: globalHotKeyListTicket];
		globalHotKeyListTicket = nil;
  }
	globalHotKeyListTicket = [[PTHotKey alloc] initWithIdentifier:@"tickifier"
                                                      keyCombo:[PTKeyCombo keyComboWithKeyCode:[shortcutRecorderListTickets keyCombo].code
                                                                                     modifiers:[shortcutRecorderListTickets cocoaToCarbonFlags: [shortcutRecorderListTickets keyCombo].flags]]];
	[globalHotKeyListTicket setTarget: self];
	[globalHotKeyListTicket setAction: @selector(hitListTicketHotKey:)];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKeyListTicket];  
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
  [self toggleNewTicketHotKey: aRecorder];
}

- (void)hitNewTicketHotKey:(PTHotKey *)hotKey {
  if([newTicketWindow isKeyWindow]){
    [self restorePreviouslyActiveApp];    

   // [[NSApplication sharedApplication] hide:self];
    [newTicketWindow setAlphaValue: 0.0f];
  }else{
    [self storePreviouslyActiveApp];    
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [newTicketWindow makeKeyAndOrderFront:self];
        [newTicketWindow setAlphaValue: 1.0f];
  }
}

- (void)hitListTicketHotKey:(PTHotKey *)hotKey {
  if([listTicketsWindow isKeyWindow]){
    [self restorePreviouslyActiveApp];

    [self slideWindows:NO fast: NO];    
  }else{
    [self storePreviouslyActiveApp];    
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [self slideWindows:YES fast: NO];
  }
}


// Thanks Visor!
#define SLIDE_EASING(x) sin(M_PI_2*(x))
#define ALPHA_EASING(x) (1.0f-(x))
#define SLIDE_DIRECTION(d,x) (d?(x):(1.0f-(x)))
#define ALPHA_DIRECTION(d,x) (d?(1.0f-(x)):(x))

- (void)slideWindows:(BOOL)direction fast:(bool)fast { // true == down
  if (!fast) {
    BOOL doSlide = YES;
    BOOL doFade = YES;
    float animSpeed = 0.3f;
    
    // animation loop
    if (doFade || doSlide) {
      if (!doSlide && direction) { // setup final slide position in case of no sliding
        float offset = SLIDE_DIRECTION(direction, SLIDE_EASING(1));
        [self placeWindow:listTicketsWindow offset:offset];
      }
      if (!doFade && direction) { // setup final alpha state in case of no alpha
        float alpha = ALPHA_DIRECTION(direction, ALPHA_EASING(1));
        [listTicketsWindow setAlphaValue: alpha];
      }
      NSTimeInterval t;
      NSDate* date=[NSDate date];
      while (animSpeed>(t=-[date timeIntervalSinceNow])) { // animation update loop
        float k=t/animSpeed;
        if (doSlide) {
          float offset = SLIDE_DIRECTION(direction, SLIDE_EASING(k));
          [self placeWindow:listTicketsWindow offset:offset];
        }
        if (doFade) {
          float alpha = ALPHA_DIRECTION(direction, ALPHA_EASING(k));
          [listTicketsWindow setAlphaValue:alpha];
        }
        usleep(5000); // 5ms
      }
    }
  }
  
  // apply final slide and alpha states
  float offset = SLIDE_DIRECTION(direction, SLIDE_EASING(1));
  [self placeWindow:listTicketsWindow offset:offset];
  float alpha = ALPHA_DIRECTION(direction, ALPHA_EASING(1));
  [listTicketsWindow setAlphaValue: alpha];
}

// offset==0.0 means window is "hidden" above top screen edge
// offset==1.0 means window is visible right under top screen edge
- (void)placeWindow:(id)win offset:(float)offset {

  NSArray* screens = [NSScreen screens];
  NSScreen* screen = [screens objectAtIndex:0];
  
  NSRect screenRect=[screen frame];
  NSRect frame=[win frame];
  int shift = 0; // see http://code.google.com/p/blacktree-visor/issues/detail?id=19
  if (screen == [[NSScreen screens] objectAtIndex: 0]) shift = 21; // menu area
//  if ([cachedPosition hasPrefix:@"Top"]) {
//  frame.origin.y = screenRect.origin.y + NSHeight(screenRect) - round(offset*(NSHeight(frame)+shift));
//  }
//  if ([cachedPosition hasPrefix:@"Left"]) {
    frame.origin.x = screenRect.origin.x - NSWidth(frame) + round(offset*NSWidth(frame));
//  }
  [win setFrame:frame display:YES];
  NSLog(@"set frame %f", frame.origin.x );
}

//more thanks to visor, removing 10.5 greatly simplified this
- (void)storePreviouslyActiveApp {
    NSDictionary *activeAppDict = [[NSWorkspace sharedWorkspace] activeApplication];
    previouslyActiveAppPID = nil;
    previouslyActiveAppPID = [activeAppDict objectForKey:@"NSApplicationProcessIdentifier"];
}

- (void)restorePreviouslyActiveApp {
  if (!previouslyActiveAppPID) return;
  id app = [NSRunningApplication runningApplicationWithProcessIdentifier: [previouslyActiveAppPID intValue]];
  if (app) {
    [app activateWithOptions:0];
  }
  previouslyActiveAppPID = nil;

}


@end
