//
//  HHAutoHidingWindow.m
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

#import "HHAutoHidingWindow.h"



@interface HHActivationWindow : NSWindow
{
	HHAutoHidingWindow *_autoHidingWindow;
	NSTrackingArea *_trackingArea;
}

- (HHActivationWindow*)initWithDelegate:(HHAutoHidingWindow*)activationDelegate;

@property (assign) HHAutoHidingWindow *autoHidingWindow;
@property (retain) NSTrackingArea *trackingArea;

- (void)adjustWindowFrame;
- (void)adjustTrackingArea;

@end


@interface HHTrackingWrapperView : NSView
{
	NSTrackingArea *_trackingArea;
}

@property (retain) NSTrackingArea *trackingArea;

@end


@interface HHAutoHidingWindow ()

- (void)autoShow;
- (void)autoHide;
- (void)scheduleHide;

@end 


@implementation HHAutoHidingWindow

- (id)initWithContentRect:(NSRect) contentRect 
				styleMask:(unsigned int) styleMask 
				  backing:(NSBackingStoreType) backingType 
					defer:(BOOL) flag
{
	
	if ((self = [super initWithContentRect:contentRect
								 styleMask:NSBorderlessWindowMask 
								   backing:backingType
									 defer:flag])) {
		_activationWindow = [[HHActivationWindow alloc] initWithDelegate:self];
	}
	
	return self;
}

@synthesize activationWindow = _activationWindow;

- (void)dealloc
{
	[_activationWindow release], _activationWindow = nil;
	
	[super dealloc];
}

- (void)makeKeyAndOrderFront:(id)sender
{
	[super makeKeyAndOrderFront:sender];
	
}

- (void)autoShow
{
	[self makeKeyAndOrderFront:self];
	
	[self scheduleHide];
}

- (void)autoHide
{
	NSPoint mouseLocation = [NSEvent mouseLocation];
	NSRect windowFrame = [self frame];
	
	if (! NSPointInRect(mouseLocation, windowFrame)) {
		[self orderOut:self];
	}
}

- (void)scheduleHide
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoHide) object:nil];
	[self performSelector:@selector(autoHide) withObject:nil afterDelay:1.5];
}

- (NSView*)wrapperViewWithFrame:(NSRect)bounds
{
	return [[[HHTrackingWrapperView alloc] initWithFrame:bounds] autorelease];
}

@end


@implementation HHActivationWindow 

- (HHActivationWindow*)initWithDelegate:(HHAutoHidingWindow*)activationDelegate
{	
	if ((self = [super initWithContentRect:[[NSScreen mainScreen] frame]
								 styleMask:NSBorderlessWindowMask
								   backing:NSBackingStoreBuffered
									 defer:NO]) != nil) {
		_autoHidingWindow = activationDelegate;
		
		[self setBackgroundColor:[NSColor clearColor]];
		[self setExcludedFromWindowsMenu:YES];
		[self setCanHide:NO];
		[self setHasShadow:NO];
		[self setLevel:NSScreenSaverWindowLevel];
		[self setAlphaValue:0.0];
		[self setIgnoresMouseEvents:YES];
		[self setOpaque:NO];
		[self orderFrontRegardless];

		[self adjustWindowFrame];
		[self.autoHidingWindow addObserver:self
								 forKeyPath:@"slidingEdge"
									options:0
									context:@"slidingEdge"];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(screenParametersChanged:) 
													 name:NSApplicationDidChangeScreenParametersNotification 
												   object:nil];		
	}
	
	return self;
}

@synthesize autoHidingWindow = _autoHidingWindow;
@synthesize trackingArea = _trackingArea;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([@"slidingEdge" isEqual:context]) {
		[self adjustTrackingArea];
	}
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self.autoHidingWindow removeObserver:self forKeyPath:@"slidingEdge"];
	_autoHidingWindow = nil;
	
	[_trackingArea release], _trackingArea = nil;
	
	[super dealloc];
}

- (void)screenParametersChanged:(NSNotification *)notification
{
	[self adjustWindowFrame];
}

- (void)adjustWindowFrame
{
	NSScreen *mainScreen = [NSScreen mainScreen];
  //  NSMenuView is depreciated
	CGFloat menuBarHeight = [[NSApp mainMenu] menuBarHeight];
	NSRect windowFrame = [mainScreen frame];
	
	windowFrame.size.height -= menuBarHeight;
	
	[self setFrame:windowFrame display:NO];
	[self adjustTrackingArea];
}

- (void)adjustTrackingArea
{
	NSView *contentView = [self contentView];
	NSRect trackingRect = contentView.bounds;	
	CGRectEdge slidingEdge = self.autoHidingWindow.slidingEdge;
	CGFloat trackingRectSize = 2.0;
	
	switch (slidingEdge) {
		case CGRectMaxXEdge:
			trackingRect.origin.x = trackingRect.origin.x + trackingRect.size.width - trackingRectSize;
			trackingRect.size.width = trackingRectSize;
			break;
			
		case CGRectMaxYEdge:
			trackingRect.origin.y = trackingRect.origin.y + trackingRect.size.height - trackingRectSize;
			trackingRect.size.height = trackingRectSize;
			break;
			
		case CGRectMinXEdge:
			trackingRect.origin.x = 0;
			trackingRect.size.width = trackingRectSize;
			break;
			
		case CGRectMinYEdge:
		default:
			trackingRect.origin.y = 0;
			trackingRect.size.height = trackingRectSize;
	}
	
	
	NSTrackingAreaOptions options =
			NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |
			NSTrackingActiveAlways |
			NSTrackingEnabledDuringMouseDrag;
	
	NSTrackingArea *trackingArea = self.trackingArea;
	
	if (trackingArea != nil) {
		[contentView removeTrackingArea:trackingArea];
	}
	
	trackingArea = [[NSTrackingArea alloc] initWithRect:trackingRect
												options:options
												  owner:self
											   userInfo:nil];
	
	[contentView addTrackingArea:trackingArea];
	
	self.trackingArea = [trackingArea autorelease];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[self.autoHidingWindow autoShow];
}


- (void)mouseMoved:(NSEvent *)theEvent
{
	[self.autoHidingWindow autoShow];
}

- (void)mouseExited:(NSEvent *)theEvent
{
}

@end


@implementation HHTrackingWrapperView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
	//	[self updateTrackingAreas];
	}
	
	return self;
}

@synthesize trackingArea = _trackingArea;

- (void)dealloc
{
	[_trackingArea release], _trackingArea = nil;
	
	[super dealloc];
}


- (void)updateTrackingAreas
{
	NSTrackingAreaOptions options =
			NSTrackingMouseEnteredAndExited | 
			NSTrackingActiveInKeyWindow |
			NSTrackingAssumeInside | NSTrackingInVisibleRect;
	
	NSTrackingArea *trackingArea = self.trackingArea;
	
	if (trackingArea != nil) {
		[self removeTrackingArea:trackingArea];
	}
	
	trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
												options:options
												  owner:self
											   userInfo:nil];
	
	[self addTrackingArea:trackingArea];
	
	self.trackingArea = [trackingArea autorelease];
	
	[super updateTrackingAreas];
}


- (void)mouseExited:(NSEvent *)theEvent
{
	HHAutoHidingWindow *window = (HHAutoHidingWindow*)[self window];
	
	[window scheduleHide];
}

@end