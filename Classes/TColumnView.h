//
//  TColumnView.h
//  Tickifier
//
//  Created by orta on 04/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TColumnView: NSView {
	NSUInteger columns, rows;
	IBOutlet NSCollectionViewItem *itemPrototype;
  IBOutlet NSArrayController *arrayController;
	NSArray *content;
	NSArray *items;
	NSArray *backgroundColours;
}

@property NSUInteger columns, rows;
@property(retain) NSCollectionViewItem *itemPrototype;
@property(copy) NSArray *content, *items;

-(void)arrangeSubviews;

@end
