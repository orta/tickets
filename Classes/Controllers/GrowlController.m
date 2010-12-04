//
//  GrowlController.m
//  Tickifier
//
//  Created by orta on 04/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "GrowlController.h"
#import "Ticket.h"

@implementation GrowlController

static NSString * const kNewTicket = @"New Ticket Created";
static NSString * const kResolveTicket = @"Ticket Resolved";

- (id) init {
  if((self = [super init])) {
    [GrowlApplicationBridge setGrowlDelegate:self];
  }
  return self;
    
}

- (NSString*) applicationNameForGrowl{
  return @"tickets app";
}

- (NSDictionary *) registrationDictionaryForGrowl {
  NSArray *notifications;
  notifications = [NSArray arrayWithObjects: kNewTicket, kResolveTicket, nil ];
  
  NSDictionary *dict;
  
  dict = [NSDictionary dictionaryWithObjectsAndKeys:
          notifications, GROWL_NOTIFICATIONS_ALL,
          notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
  
  return (dict);
}

- (void) postNotificationForNewTicket:(Ticket*) ticket {
  [GrowlApplicationBridge notifyWithTitle:@"Ticket Created" description: ticket.title notificationName:kNewTicket iconData:nil priority:0 isSticky:FALSE clickContext:nil];
}

- (void) postNotificationForResolvedTicket:(Ticket*) ticket {
  NSString * subtext = [NSString stringWithFormat:@"%@ (%@)", ticket.title, ticket.identifier];
  [GrowlApplicationBridge notifyWithTitle:@"Ticket Resolved" description:subtext  notificationName:kResolveTicket iconData:nil priority:0 isSticky:FALSE clickContext:nil];
}


@end
