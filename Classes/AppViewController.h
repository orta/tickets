//
//  PrefsViewController.h
//  Tickifier
//
//  Created by Ben Maslen on 19/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppViewController : NSObject {
  IBOutlet NSTextView *bodyTextView;
  IBOutlet NSTokenField *tagsTextField;
  
  IBOutlet NSWindow *mainWindow;
  IBOutlet NSView *accessoryView;
}

- (void)composeInterface;


@end
