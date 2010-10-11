//
//  ORBackwardsScrollView.m
//  Tickifier
//
//  Created by orta on 11/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "ORBackwardsScrollView.h"

@implementation ORBackwardsScrollView

-(void) awakeFromNib {  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( handleFrameDidChange: )
                                               name:@"NSViewFrameDidChangeNotification" object:self];
}

// This gets called 
- (void) handleFrameDidChange:( NSNotification* ) note
{  
  NSRect frame = [_vScroller frame];
  frame.origin.x = 4;
  frame.size.height += 14;
  [_vScroller setFrame:frame];
  return;
}

@end
