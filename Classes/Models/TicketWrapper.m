//
//  TicketWrapper.m
//  Tickifier
//
//  Created by orta on 12/03/2011.
//  Copyright 2011 http://www.ortatherox.com. All rights reserved.
//

#import "TicketWrapper.h"
#import "Ticket.h"

@implementation TicketWrapper

+ (TicketWrapper *) ticketWrapperWithTicket: (Ticket *) t{
  TicketWrapper * tw = [[TicketWrapper alloc] init];
  tw.ticket = t;
  return tw;
}

- (NSString*) generateTimeString {
  return @"Henk said at 4am last night";
}

- (void)setSelected:(BOOL)isSelected {
  NSLog(@"selected");
  selected = isSelected;  
  self.textColor = selected? [NSColor whiteColor] : [NSColor textColor];
}

@synthesize ticket, selected, textColor;
@end
