//
//  GrowlController.h
//  Tickifier
//
//  Created by orta on 04/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
@class Ticket;

@interface GrowlController : NSObject <GrowlApplicationBridgeDelegate> {}

- (void) postNotificationForNewTicket:(Ticket*) ticket;
- (void) postNotificationForResolvedTicket:(Ticket*) ticket;

@end
