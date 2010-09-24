//
//  ORCycleTextField.m
//  Tickifier
//
//  Created by Ben Maslen on 24/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "ORCycleTextField.h"


@implementation ORCycleTextField

@dynamic strings;

- (void) awakeFromNib {
  self.strings = [NSArray arrayWithObjects:@"need strings", @"please", nil];
  [self mouseDown:nil];
  currentIndex = 1;
}

- (void) mouseDown: (NSEvent *) event {
  if ( currentIndex == [strings count] ) {
    currentIndex = 0;
  }
  [self setStringValue:[strings objectAtIndex:currentIndex++]];

}
  
- (void) setStrings:(NSArray*) newStrings{
  strings = newStrings;
  [self setStringValue:[strings objectAtIndex:currentIndex]];
}


@end
