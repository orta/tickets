//
//  TickifierAppDelegate.h
//  Tickifier
//
//  Created by orta therox on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTHotKey.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface TickifierAppDelegate : NSObject <NSApplicationDelegate> {
  IBOutlet NSWindow *newTicketWindow;
    IBOutlet NSWindow *listTicketsWindow;
  IBOutlet NSWindow *setupWindow;
  
  IBOutlet SRRecorderControl *shortcutRecorderNewTicket;
	PTHotKey *globalHotKeyNewTicket;
  
  IBOutlet SRRecorderControl *shortcutRecorderListTickets;
	PTHotKey *globalHotKeyListTicket;
  
  NSString* previouslyActiveAppPath;
  NSNumber* previouslyActiveAppPID;
  
  BOOL openAtStartup;
 }

- (IBAction)toggleNewTicketHotKey:(id)sender;
- (IBAction)toggleListTicketsHotKey:(id)sender;
- (IBAction)toggleLoadOnStartup:(id)sender;
- (IBAction)newTicket:(id)sender;

- (void)hideAll:(id)sender;
- (void)slideWindow:(NSWindow*)window direction:(BOOL)direction doSlide:(bool)doSlide;
- (void)placeWindow:(id)win offset:(float)offset;

- (void)storePreviouslyActiveApp;
- (void)restorePreviouslyActiveApp;


@property (retain) IBOutlet NSWindow *newTicketWindow;
@property (retain) IBOutlet NSWindow *setupWindow;
@property ()  BOOL openAtStartup;
@end
