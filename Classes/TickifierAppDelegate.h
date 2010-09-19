//
//  TickifierAppDelegate.h
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "PTHotKey.h"

@interface TickifierAppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow *window;
  IBOutlet NSWindow *setupWindow;
  
  IBOutlet SRRecorderControl *shortcutRecorder;
	PTHotKey *globalHotKey;
}

- (IBAction)toggleGlobalHotKey:(id)sender;

@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSWindow *setupWindow;
@end
