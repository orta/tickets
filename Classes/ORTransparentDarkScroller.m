//
//  ORTransparentDarkScroller.m
//  Tickifier
//
//  Created by orta on 11/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "ORTransparentDarkScroller.h"

// Vertical scroller
static NSImage *knobTop, *knobVerticalFill, *knobBottom, *slotTop, *slotVerticalFill, *slotBottom;
static float verticalPaddingLeft = 0.0;
static float verticalPaddingRight = 1.0;
static float verticalPaddingTop = 2.0;
static float verticalPaddingBottom = 0.0;
static float minKnobHeight;

// Horizontal scroller
static NSImage *knobLeft, *knobHorizontalFill, *knobRight, *slotLeft, *slotHorizontalFill, *slotRight;
static float horizontalPaddingLeft = 2.0;
static float horizontalPaddingRight = 2.0;
static float horizontalPaddingTop = 0.0;
static float horizontalPaddingBottom = 1.0;
static float minKnobWidth;

@interface BWTransparentScroller (BWTSPrivate)
- (void)drawKnobSlot;
@end


@implementation ORTransparentDarkScroller

- (void)drawRect:(NSRect)aRect;
{
	
	// Only draw if the slot is larger than the knob
	if (isVertical && ([self bounds].size.height - verticalPaddingTop - verticalPaddingBottom + 1) > minKnobHeight)
   {
		//[self drawKnobSlot];
		
		if ([self knobProportion] > 0.0)	
			[self drawKnob];
   }
	else if (!isVertical && ([self bounds].size.width - horizontalPaddingLeft - horizontalPaddingRight + 1) > minKnobWidth)
   {
	//	[self drawKnobSlot];
    
		if ([self knobProportion] > 0.0)	
			[self drawKnob];
   }
}

@end
