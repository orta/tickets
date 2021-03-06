//
//  OSStartupController..m
//  Tickifier
//
//  Created by orta on 17/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "OSStartupController.h"
#import <Carbon/Carbon.h>

@implementation OSStartupController

// MIT licensed, but thanks http://www.bdunagan.com/

+ (BOOL)isLaunchAtStartup {
	// See if the app is currently in LoginItems.
	LSSharedFileListItemRef itemRef = [self itemRefInLoginItems];
	// Store away that boolean.
	BOOL isInList = itemRef != nil;
	// Release the reference if it exists.
	if (itemRef != nil) CFRelease(itemRef);
  
	return isInList;
}

+ (IBAction)toggleLaunchAtStartup:(id)sender {
	// Toggle the state.
	BOOL shouldBeToggled = ![self isLaunchAtStartup];
	// Get the LoginItems list.
	LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	if (loginItemsRef == nil) return;
	if (shouldBeToggled) {
		// Add the app to the LoginItems list.
		CFURLRef appUrl = (CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
		LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, appUrl, NULL, NULL);
		if (itemRef) CFRelease(itemRef);
	}
	else {
		// Remove the app from the LoginItems list.
		LSSharedFileListItemRef itemRef = [self itemRefInLoginItems];
		LSSharedFileListItemRemove(loginItemsRef,itemRef);
		if (itemRef != nil) CFRelease(itemRef);
	}
	CFRelease(loginItemsRef);
}

+ (LSSharedFileListItemRef)itemRefInLoginItems {
	LSSharedFileListItemRef itemRef = nil;
	NSURL *itemUrl = nil;
  
	// Get the app's URL.
	NSURL *appUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	// Get the LoginItems list.
	LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	if (loginItemsRef == nil) return nil;
	// Iterate over the LoginItems.
	NSArray *loginItems = (NSArray *)LSSharedFileListCopySnapshot(loginItemsRef, nil);
	for (int currentIndex = 0; currentIndex < [loginItems count]; currentIndex++) {
		// Get the current LoginItem and resolve its URL.
		LSSharedFileListItemRef currentItemRef = (LSSharedFileListItemRef)[loginItems objectAtIndex:currentIndex];
		if (LSSharedFileListItemResolve(currentItemRef, 0, (CFURLRef *) &itemUrl, NULL) == noErr) {
			// Compare the URLs for the current LoginItem and the app.
			if ([itemUrl isEqual:appUrl]) {
				// Save the LoginItem reference.
				itemRef = currentItemRef;
			}
		}
	}
	// Retain the LoginItem reference.
	if (itemRef != nil) CFRetain(itemRef);
	// Release the LoginItems lists.
	[loginItems release];
	CFRelease(loginItemsRef);
  
	return itemRef;
}

@end
