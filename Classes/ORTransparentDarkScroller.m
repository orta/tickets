//
//  ORTransparentDarkScroller.m
//  Tickifier
//
//  Created by orta on 11/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "ORTransparentDarkScroller.h"


// Horizontal scroller
static float horizontalPaddingLeft = 2.0;
static float horizontalPaddingRight = 2.0;
static float minKnobWidth;

@interface BWTransparentScroller (BWTSPrivate)
- (void)drawKnobSlot;
@end


@implementation ORTransparentDarkScroller

- (void)drawRect:(NSRect)aRect;
{
	
	// Only draw if the slot is larger than the knob
	if (isVertical)
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
