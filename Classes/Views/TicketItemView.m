//
//  TicketItemView.m
//  Tickifier
//
//  Created by orta on 11/03/2011.
//  Copyright 2011 http://www.ortatherox.com. All rights reserved.
//

#import "TicketItemView.h"
#import "Ticket.h"

@implementation TicketItemView

+ (TicketItemView *) ticketItemViewWithTicket:(Ticket *)t {
  static NSNib *nib = nil;
  if(nib == nil) {
    nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass(self) bundle:nil];
  }
  
  NSArray *objects = nil;
  [nib instantiateNibWithOwner:t topLevelObjects:&objects];
  for(id object in objects) {
    if([object isKindOfClass:self]) {
      [object setTicket:t];
      return object;
    }
  }
  
  NSAssert1(NO, @"No view of class %@ found.", NSStringFromClass(self));
  return nil;
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)setSelected:(BOOL)isSelected {
  selected = isSelected;
  [self setNeedsDisplay:YES];
}

@synthesize selected;
@synthesize ticket;
@end
