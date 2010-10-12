//
//  LighthouseServer.m
//  Tickifier
//
//  Created by orta on 12/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "LighthouseServer.h"


@implementation LighthouseServer

@synthesize url, APIKey;

- (id)copyWithZone:(NSZone *)aZone {
  LighthouseServer*   result = [[self class] allocWithZone:aZone]; 
  result.url = self.url;
  result.APIKey = self.APIKey;
  return result;
}  

- (void)encodeWithCoder: (NSCoder *)coder {
  [coder encodeObject: [self url] forKey: @"url"];
  [coder encodeObject: [self APIKey] forKey: @"APIKey"];
}

- (id)initWithCoder: (NSCoder *)coder {
  if((self = [self init]))
   {
    self.url = [coder decodeObjectForKey: @"url"];
    self.APIKey = [coder decodeObjectForKey: @"APIKey"];
   }
  return self;
}

@end
