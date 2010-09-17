//
//  Project.h
//  Tickifier
//
//  Created by Ben Maslen on 17/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Project : NSObject {
  NSString * name;
  NSInteger identifier;
}

@property (retain) NSString *name;
@property () NSInteger identifier;

@end
