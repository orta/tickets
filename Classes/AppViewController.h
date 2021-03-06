//
//  PrefsViewController.h
//  Tickifier
//
//  Created by orta therox on 19/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppViewController : NSObject {
  IBOutlet NSTextView *bodyTextView;
  IBOutlet NSTextField *tagsTextField;
  
  IBOutlet NSWindow *ticketWindow;
  IBOutlet NSView *accessoryView;
  
//  IBOutlet AMCollectionView *ticketCollectionView;
  Boolean fullView;
}

- (IBAction) toggleViewMode:(id)sender;

@property () Boolean fullView;

@end
