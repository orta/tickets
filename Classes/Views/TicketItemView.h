//
//  TicketItemView.h
//  Tickifier
//
//  Created by orta on 11/03/2011.
//  Copyright 2011 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JAListViewItem.h"

@class Ticket, TicketWrapper;

@interface TicketItemView : JAListViewItem {
  BOOL selected;
  NSGradient *gradient;
  NSGradient *selectedGradient;
  
  TicketWrapper *ticketWrapper;
}

+ (TicketItemView *) ticketItemViewWithTicket:(Ticket *)t;
- (void) setSelected:(BOOL)isSelected;

@property (nonatomic, retain) TicketWrapper *ticketWrapper;

@end