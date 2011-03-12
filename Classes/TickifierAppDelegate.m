//
//  TickifierAppDelegate.m
//  Tickifier
//
//  Created by orta therox on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import "TickifierAppDelegate.h"
#import "PTHotKeyCenter.h"
#import "OSStartupController.h"

@implementation TickifierAppDelegate

@synthesize newTicketWindow, setupWindow, openAtStartup;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAll:) name:NSApplicationDidResignActiveNotification object: [NSApplication sharedApplication]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAll:) name:NSApplicationDidHideNotification object: [NSApplication sharedApplication]];
  
  [self toggleNewTicketHotKey:self];
  [self toggleListTicketsHotKey:self];

  NSRect frame = [listTicketsWindow frame];
  frame.size.height = [[[NSScreen screens] objectAtIndex:0] frame].size.height - 21;
  frame.origin.x = 0;
  [listTicketsWindow setFrame:frame display:NO];
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:@"api_key"]){
    [newTicketWindow becomeKeyWindow];
    [newTicketWindow orderFrontRegardless];
  }else{
    [setupWindow becomeKeyWindow];
    [setupWindow orderFrontRegardless];
    [setupWindow center];
  }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{
  [self hitListTicketHotKey:nil];
  return YES;
}

- (IBAction)newTicket:(id)sender {
  if([newTicketWindow isKeyWindow] == NO){
    [newTicketWindow makeKeyAndOrderFront:self];
    [self slideWindow:newTicketWindow direction:YES doSlide:NO];    
  }
}

- (IBAction)toggleLoadOnStartup:(id)sender {
  [OSStartupController toggleLaunchAtStartup:self];
} 

- (BOOL) getOpenAtStartup {
  return [OSStartupController isLaunchAtStartup];
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
    [self hideAll:self];

  }else{
    [self storePreviouslyActiveApp];    
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [newTicketWindow makeKeyAndOrderFront:self];
    [self slideWindow:newTicketWindow direction:YES doSlide:NO];
  }
}

- (void)hitListTicketHotKey:(PTHotKey *)hotKey {
  // dock hits send through a nik hotkey
  if([listTicketsWindow isKeyWindow] && hotKey != nil){
    [self restorePreviouslyActiveApp];
    [self hideAll:self];

  }else{
    [self storePreviouslyActiveApp];    
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [listTicketsWindow makeKeyAndOrderFront:self];
    [self slideWindow:listTicketsWindow direction:YES doSlide:YES];

  }
}

-(void)hideAll:(id)sender {
  if([listTicketsWindow alphaValue] == 1){
    [self slideWindow:listTicketsWindow direction:NO doSlide:YES];    
  }
  if([newTicketWindow alphaValue] == 1){
    [self slideWindow:newTicketWindow direction:NO doSlide:NO];
  }
}

// Thanks Visor!
#define SLIDE_EASING(x) sin(M_PI_2*(x))
#define ALPHA_EASING(x) (1.0f-(x))
#define SLIDE_DIRECTION(d,x) (d?(x):(1.0f-(x)))
#define ALPHA_DIRECTION(d,x) (d?(1.0f-(x)):(x))

- (void)slideWindow:(NSWindow*)window direction:(BOOL)direction doSlide:(bool)doSlide { // true == down
  return;
  BOOL doFade = YES;
  float animSpeed = 0.3f;
  
  // animation loop
  if (doFade || doSlide) {
//    if (!doSlide && direction) { // setup final slide position in case of no sliding
//      float offset = SLIDE_DIRECTION(direction, SLIDE_EASING(1));
//      [self placeWindow:window offset:offset];
//    }
    if (!doFade && direction) { // setup final alpha state in case of no alpha
      float alpha = ALPHA_DIRECTION(direction, ALPHA_EASING(1));
      [window setAlphaValue: alpha];
    }
    NSTimeInterval t;
    NSDate* date=[NSDate date];
    while (animSpeed>(t=-[date timeIntervalSinceNow])) { // animation update loop
      float k=t/animSpeed;
      if (doSlide) {
        float offset = SLIDE_DIRECTION(direction, SLIDE_EASING(k));
        [self placeWindow:window offset:offset];
      }
      if (doFade) {
        float alpha = ALPHA_DIRECTION(direction, ALPHA_EASING(k));
        [window setAlphaValue:alpha];
      }
      usleep(5000); // 5ms
    }
  }
  
  // apply final slide and alpha states
  if (doSlide) {
    float offset = SLIDE_DIRECTION(direction, SLIDE_EASING(1));
    [self placeWindow:window offset:offset];
  }
    float alpha = ALPHA_DIRECTION(direction, ALPHA_EASING(1));
  [window setAlphaValue: alpha];
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
}

//more thanks to visor, removing 10.5 greatly simplified this
- (void)storePreviouslyActiveApp {
  NSDictionary *activeAppDict = [[NSWorkspace sharedWorkspace] activeApplication];
  previouslyActiveAppPID = nil;
  if ([(NSString*)[activeAppDict objectForKey:@"NSApplicationBundleIdentifier"] compare:@"com.ortatherox.Tickifier"]) {
    previouslyActiveAppPID = [activeAppDict objectForKey:@"NSApplicationProcessIdentifier"];
  }
  
}

- (void)restorePreviouslyActiveApp {
  if (!previouslyActiveAppPID) 
    [[NSApplication sharedApplication] hide:self];
  id app = [NSRunningApplication runningApplicationWithProcessIdentifier: [previouslyActiveAppPID intValue]];
  if (app) {
    [app activateWithOptions:0];
  }
  previouslyActiveAppPID = nil;
}


@end
