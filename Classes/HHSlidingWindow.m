//
//  HHSlidingWindow.m
//
// Copyright (c) 2010 Houdah Software s.à r.l. (http://www.houdah.com)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "HHSlidingWindow.h"


@interface HHSlidingWindow ()

- (void)adjustWrapperView;

- (void)setWindowWidth:(NSNumber*)width;
- (void)setWindowHeight:(NSNumber*)height;

@end


@implementation HHSlidingWindow

@synthesize slidingEdge = _slidingEdge;
@synthesize wrapperView = _wrapperView;


- (id)initWithContentRect:(NSRect) contentRect 
				styleMask:(unsigned int) styleMask 
				  backing:(NSBackingStoreType) backingType 
					defer:(BOOL) flag
{
	
	if ((self = [super initWithContentRect:contentRect
								 styleMask:NSBorderlessWindowMask 
								   backing:backingType
									 defer:flag])) {
		/* May want to setup some other options, 
		 like transparent background or something */
		
		[self setSlidingEdge:CGRectMinXEdge];
		[self setHidesOnDeactivate:YES];
		[self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
	}
	
	return self;
}

- (NSView*)wrapperViewWithFrame:(NSRect)bounds
{
	return [[[NSView alloc] initWithFrame:bounds] autorelease];
}

- (void)adjustWrapperView
{
	if (self.wrapperView == nil) {
		NSRect frame = [self frame];
		NSRect bounds = NSMakeRect(0, 0, frame.size.width, frame.size.height);
		NSView *wrapperView = [self wrapperViewWithFrame:bounds];
		NSArray *subviews =  [[[[self contentView] subviews] copy] autorelease];
		
		for (NSView *view in subviews) {
			[wrapperView addSubview:view];
		}
		
		[wrapperView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[[self contentView] addSubview:wrapperView];
		
		self.wrapperView = wrapperView;
	}
		
	switch (self.slidingEdge) {
		case CGRectMaxXEdge:
			[self.wrapperView setAutoresizingMask:(NSViewHeightSizable | NSViewMaxXMargin)];
			break;
			
		case CGRectMaxYEdge:
			[self.wrapperView setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];
			break;
			
		case CGRectMinXEdge:
			[self.wrapperView setAutoresizingMask:(NSViewHeightSizable | NSViewMinXMargin)];
			break;
			
		case CGRectMinYEdge:
		default:
			[self.wrapperView setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin)];
	}
}

- (void)makeKeyAndOrderFront:(id)sender
{
	[self adjustWrapperView];
	
	if ([self isKeyWindow]) {
		[super makeKeyAndOrderFront:sender];
	}
	else {
		NSRect screenRect = [[NSScreen mainScreen] visibleFrame];
		NSRect windowRect = [self frame];
		
		CGFloat x;
		CGFloat y;
		NSRect startWindowRect;
		NSRect endWindowRect;

		switch (self.slidingEdge) {
			case CGRectMinXEdge:
				x = 0;
				y = (screenRect.size.height - windowRect.size.height) / 2 + screenRect.origin.y;
				startWindowRect = NSMakeRect(x - windowRect.size.width, y, 0, windowRect.size.height);
				break;
				
			case CGRectMinYEdge:
				x = (screenRect.size.width - windowRect.size.width) / 2 + screenRect.origin.x;
				y = 0;
				startWindowRect = NSMakeRect(x, y - windowRect.size.height, windowRect.size.width, 0);
				break;
				
			case CGRectMaxXEdge:
				x = screenRect.size.width - windowRect.size.width + screenRect.origin.x;
				y = (screenRect.size.height - windowRect.size.height) / 2 + screenRect.origin.y;
				startWindowRect = NSMakeRect(x + windowRect.size.width, y, 0, windowRect.size.height);
				break;
				
			case CGRectMaxYEdge:
			default:
				x = (screenRect.size.width - windowRect.size.width) / 2 + screenRect.origin.x;
				y = screenRect.size.height - windowRect.size.height + screenRect.origin.y;
				startWindowRect = NSMakeRect(x, y + windowRect.size.height, windowRect.size.width, 0);
		}
		
		endWindowRect = NSMakeRect(x, y, windowRect.size.width, windowRect.size.height);
		
		[self setFrame:startWindowRect display:NO animate:NO];

		[super makeKeyAndOrderFront:sender];
		
		[self setFrame:endWindowRect display:YES animate:YES];
		
		[self performSelector:@selector(makeResizable)
				   withObject:nil
				   afterDelay:1];
	}
}

- (void)makeResizable
{
	NSView *wrapperView = self.wrapperView;
	NSRect frame = [self frame];
	NSRect bounds = NSMakeRect(0, 0, frame.size.width, frame.size.height);
	
	[wrapperView setFrame:bounds];
	[wrapperView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
}

- (void)orderOut:(id)sender
{
	[self adjustWrapperView];

	NSRect startWindowRect = [self frame];
	NSRect endWindowRect;
	
	switch (self.slidingEdge) {
		case CGRectMinXEdge:
			endWindowRect = NSMakeRect(startWindowRect.origin.x, 
									   startWindowRect.origin.y,
									   0,
									   startWindowRect.size.height);
			break;
			
		case CGRectMinYEdge:
			endWindowRect = NSMakeRect(startWindowRect.origin.x, 
									   startWindowRect.origin.y, 
									   startWindowRect.size.width, 
									   0);
			break;
			
		case CGRectMaxXEdge:
			endWindowRect = NSMakeRect(startWindowRect.origin.x + startWindowRect.size.width, 
									   startWindowRect.origin.y,
									   0,
									   startWindowRect.size.height);
			break;
			
		case CGRectMaxYEdge:
		default:
			endWindowRect = NSMakeRect(startWindowRect.origin.x, 
									   startWindowRect.origin.y + startWindowRect.size.height, 
									   startWindowRect.size.width, 
									   0);
	}
		
	[self setFrame:endWindowRect display:YES animate:YES];
	
	switch (self.slidingEdge) {
		case CGRectMaxXEdge:
		case CGRectMinXEdge:
			if (startWindowRect.size.width > 0) {
				[self performSelector:@selector(setWindowWidth:)
						   withObject:[NSNumber numberWithDouble:startWindowRect.size.width]
						   afterDelay:0];
			}
			break;
			
		case CGRectMaxYEdge:
		case CGRectMinYEdge:
		default:
			if (startWindowRect.size.height > 0) {
				[self performSelector:@selector(setWindowHeight:)
						   withObject:[NSNumber numberWithDouble:startWindowRect.size.height]
						   afterDelay:0];
			}
	}
	
	
	[super orderOut:sender];
}

- (void)setWindowWidth:(NSNumber*)width
{
	NSRect startWindowRect = [self frame];
	NSRect endWindowRect = NSMakeRect(startWindowRect.origin.x, 
									  startWindowRect.origin.y, 
									  [width doubleValue],
									  startWindowRect.size.height);
	
	[self setFrame:endWindowRect display:NO animate:NO];	
}

- (void)setWindowHeight:(NSNumber*)height
{
	NSRect startWindowRect = [self frame];
	NSRect endWindowRect = NSMakeRect(startWindowRect.origin.x, 
									  startWindowRect.origin.y, 
									  startWindowRect.size.width, 
									  [height doubleValue]);
	
	[self setFrame:endWindowRect display:NO animate:NO];	
}

- (void)resignKeyWindow
{
	[self orderOut:self];
	
	[super resignKeyWindow];
}

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (void)performClose:(id)sender
{
	[self close];
}

- (void)dealloc
{
	[_wrapperView release], _wrapperView = nil;

	[super dealloc];
}

@end