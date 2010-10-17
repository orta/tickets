//
//  LighthouseServer.m
//  Tickifier
//
//  Created by orta on 12/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "Server.h"


@implementation Server

@synthesize url, APIKey, projectIndex, milestoneIndex, userIndex;

- (NSString*) description {
  return [NSString stringWithFormat:@"%@ : projectID: %i userID %i milestoneID %i", self.url, self.projectIndex, self.userIndex, self.milestoneIndex ];
}

- (void)encodeWithCoder: (NSCoder *)coder {
  NSLog(@"ENCODING %@", self);
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
  NSLog(@"UNENCODED %@", self);
  return self;
}

@end
