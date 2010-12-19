//
//  TColumnView.m
//  Tickifier
//
//  Created by orta on 04/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//  This is not my code, this is TCollectionView from http://cocoadev.com/index.pl?NSCollectionView
//  Adaptions being binding to arrayControllers and defaulting the amount of columns

#import "TColumnView.h"


@implementation TColumnView

@synthesize columns, rows, itemPrototype, content, items;

-(void)awakeFromNib {
	backgroundColours = [[NSArray arrayWithObjects:
                        [NSColor whiteColor],
                        [NSColor colorWithCalibratedHue: 0 saturation: 0 brightness: 0.94 alpha: 1.0],
                        nil] retain];
  self.columns = 1;
  
  [self bind:@"content" toObject:arrayController withKeyPath:@"content" options:nil];
}

-(NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
	NSCollectionViewItem *item = [self.itemPrototype copy];
	item.representedObject = object;
	return item;
}

-(void)setupSubviews {
	NSMutableArray *is = [NSMutableArray array];
	[self setSubviews: [NSArray array]];
	for(id representedObject in self.content) {
		NSCollectionViewItem *item = [[self newItemForRepresentedObject: representedObject] autorelease];
		[is addObject: item];
		[self addSubview: item.view];
	}
	self.items = is;
}

-(void)arrangeSubviews {
	NSPoint offset = NSMakePoint(0.0, 0.0);
	[self setFrameSize: NSMakeSize(self.frame.size.width, [self enclosingScrollView].frame.size.height)];
	for(NSView *view in self.subviews) {
		[view setFrameOrigin: offset];
		[view setFrameSize: NSMakeSize(self.frame.size.width, view.frame.size.height)];
		offset = NSMakePoint(offset.x, offset.y + view.frame.size.height);
		[[self animator] setFrameSize: NSMakeSize(self.frame.size.width, view.frame.origin.y + view.frame.size.height)];
	}
	[self setNeedsDisplay: YES];
}

-(void)setContent:(NSArray *)c {
	if(content != c) {
		[self willChangeValueForKey: @"content"];
		[content release];
		content = [c retain];
		[self setupSubviews];
		[self didChangeValueForKey: @"content"];
	}
	[self arrangeSubviews];
}

-(BOOL)isFlipped {
	return YES;
}

-(void)drawRect:(NSRect)rect {
	[[NSColor whiteColor] set];
	NSRectFill([self frame]);
	NSUInteger i = 0;
	for(NSView *view in self.subviews) {
		[[backgroundColours objectAtIndex: i % [backgroundColours count]] set];
		NSRectFill([view frame]);
		i++;
	}
}

@end
