//
//  TicketWrapper.h
//  Tickifier
//
//  Created by orta on 12/03/2011.
//  Copyright 2011 http://www.ortatherox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Ticket;
@interface TicketWrapper : NSObject {
  Ticket * ticket;
  BOOL selected;
  NSColor *textColor;
}

@property (nonatomic, copy) NSColor *textColor;
@property Ticket * ticket;
@property BOOL selected;

+ (TicketWrapper *) ticketWrapperWithTicket: (Ticket *) t;

- (void)setSelected:(BOOL)isSelected;
- (NSString*) generateTimeString;

@end
