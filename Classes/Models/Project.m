//
//  Project.m
//  Tickifier
//
//  Created by Ben Maslen on 17/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "Project.h"


@implementation Project

@synthesize identifier, name;

- (NSString * )description {
  return [NSString stringWithFormat:@"%@ (%i) ", self.name, self.identifier];
}

@end
