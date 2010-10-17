//
//  MixerCategory.h
//  Tickifier
//
//  Created by orta on 17/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Ticket;
@class Server;
@class ServerController;

@protocol Mixer

- (void) setServer:(Server *)server;
- (void) setController:(ServerController *)controller;

- (void) getTickets;
- (void) getProjects;
- (void) getMilestones;
- (void) getUsers;

- (void) createNewTicket: (Ticket *)ticket;
- (void) resolveTicket: (Ticket *)ticket;
- (void) invalidateTicket: (Ticket *)ticket;

@end
