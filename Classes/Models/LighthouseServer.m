//
//  LighthouseServer.m
//  Tickifier
//
//  Created by orta on 12/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "LighthouseServer.h"


@implementation LighthouseServer

@synthesize url, APIKey, projectIndex, milestoneIndex, userIndex;

- (void)encodeWithCoder: (NSCoder *)coder {
  [coder encodeObject: [self url] forKey: @"url"];
  [coder encodeObject: [self APIKey] forKey: @"APIKey"];
  [coder encodeInt:self.userIndex forKey:@"userIndex"];
  [coder encodeInt:self.milestoneIndex forKey:@"milestoneIndex"];
  [coder encodeInt:self.projectIndex forKey:@"projectIndex"];
  
}

- (id)initWithCoder: (NSCoder *)coder {
  if((self = [self init])) {
    self.url = [coder decodeObjectForKey: @"url"];
    self.APIKey = [coder decodeObjectForKey: @"APIKey"];
    self.userIndex = [coder decodeIntForKey:@"userIndex"];
    self.milestoneIndex = [coder decodeIntForKey:@"milestoneIndex"];
    self.projectIndex = [coder decodeIntForKey:@"projectIndex"];
   }
  return self;
}

@end
