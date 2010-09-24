//
//  ORCycleTextField.h
//  Tickifier
//
//  Created by Ben Maslen on 24/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ORCycleTextField : NSTextField {

  NSArray *strings;
  int currentIndex;
  
}
@property (retain) NSArray *strings;

@end
