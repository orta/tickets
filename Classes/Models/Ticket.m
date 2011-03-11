//
//  Ticket.m
//  Tickifier
//
//  Created by orta therox on 16/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "Ticket.h"


@implementation Ticket
@synthesize title, body, tags, identifier, url;

+ (Ticket *) ticketWithXMLElement: (NSXMLElement *) element {
  Ticket * t = [[[Ticket alloc] init] autorelease];
  t.title = [[[element elementsForName:@"title"] objectAtIndex:0] stringValue];
  t.identifier = [[[element elementsForName:@"number"] objectAtIndex:0] stringValue];
  t.url = [[[element elementsForName:@"url"] objectAtIndex:0] stringValue];
  t.tags = [[[element elementsForName:@"tag"] objectAtIndex:0] stringValue];
  return t;
}

-(id)copyWithZone:(NSZone*)zone {
	Ticket *t = [[[self class] allocWithZone:zone] init];
  t.title = self.title;
  t.identifier = self.identifier;
  t.url = self.url;
  t.tags = self.tags;
  return t;
}


@end
