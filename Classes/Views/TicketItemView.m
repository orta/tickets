//
//  TicketItemView.m
//  Tickifier
//
//  Created by orta on 11/03/2011.
//  Copyright 2011 http://www.ortatherox.com. All rights reserved.
//

#import "TicketItemView.h"
#import "Ticket.h"
#import "TicketWrapper.h"

// privs, yeah?
@interface TicketItemView ()
- (void) setupGradients;
@end



@implementation TicketItemView

+ (TicketItemView *) ticketItemViewWithTicket:(Ticket *)t {
  static NSNib *nib = nil;
  if(nib == nil) {
    nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass(self) bundle:nil];
  }
  
  TicketWrapper * ticketWrapper = [TicketWrapper ticketWrapperWithTicket:t];
  NSArray *objects = nil;
  
  [nib instantiateNibWithOwner:ticketWrapper topLevelObjects:&objects];
  for(id object in objects) {
    if([object isKindOfClass:self]) {
      [object setTicketWrapper:ticketWrapper];
      [object setSelected:false];
      [object setupGradients];
      return object;
    }
  }
  
  NSAssert1(NO, @"No view of class %@ found.", NSStringFromClass(self));
  return nil;
}

-(void) setupGradients {
  gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.8f alpha:1.0f] endingColor:[NSColor colorWithDeviceWhite:0.85f alpha:1.0f]];
  
  selectedGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.086 green:0.398 blue:0.997 alpha:1.000] endingColor:[NSColor colorWithCalibratedRed:0.044 green:0.334 blue:0.872 alpha:1.000]];
}

- (void)drawRect:(NSRect)dirtyRect {
  if(self.selected) {
    [selectedGradient drawInRect:self.bounds angle:self.selected ? 270.0f : 90.0f];   
  }else{
    [gradient drawInRect:self.bounds angle:self.selected ? 270.0f : 90.0f];   
  }
 
  
  [[NSColor colorWithDeviceWhite:0.5f alpha:1.0f] set];
  NSRectFill(NSMakeRect(0.0f, 0.0f, self.bounds.size.width, 1.0f));
  
  [[NSColor colorWithDeviceWhite:0.93f alpha:1.0f] set];
  NSRectFill(NSMakeRect(0.0f, self.bounds.size.height - 1.0f, self.bounds.size.width, 1.0f));
}

- (void) setSelected:(BOOL)isSelected {
  selected = isSelected;
  ticketWrapper.selected = isSelected;
    
  //  hacky height thing. must be a better way
  NSRect frame = [self frame];
  frame.size.height = selected ? 200.0f : 50.0f; 
  [self setFrame: frame];
  
  [self setNeedsDisplay:YES];
}

@synthesize selected;
@synthesize ticketWrapper;
@end
