//
//  LighthouseController.h
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LighthouseEntity.h"
#import "Ticket.h"
#import "LighthouseServer.h"

@interface LighthouseController : NSObject {
  
  IBOutlet NSWindow *ticketWindow;
  IBOutlet NSTextField * passwordField;
  
  LighthouseServer *currentServer;
  
  LighthouseEntity *currentProject;
  LighthouseEntity *currentMilestone;
  LighthouseEntity *currentAssignedToUser;

  Ticket *currentTicket;
  
  IBOutlet NSArrayController *servers;
  IBOutlet NSArrayController *projects;
  IBOutlet NSArrayController *milestones;
  IBOutlet NSArrayController *users;
  IBOutlet NSArrayController *tickets;
  NSInteger projectIndex;
  NSInteger milestoneIndex;
  NSInteger assignedToUserIndex;
  
  NSString *status;
  
	NSMutableData *payload;
}

@property (retain) NSArrayController *projects;
@property (retain) NSArrayController *milestones;
@property (retain) NSArrayController *users;
@property (retain) NSArrayController *tickets;

@property (retain) Ticket *currentTicket;

@property (retain) LighthouseEntity *currentProject;
@property (retain) LighthouseEntity *currentMilestone;
@property (retain) LighthouseEntity *currentAssignedToUser;

@property (retain) LighthouseServer *currentServer;

@property () NSInteger projectIndex;
@property () NSInteger milestoneIndex;
@property () NSInteger assignedToUserIndex;

@property (retain) NSString *status;

- (IBAction) submit:(id)sender;
- (IBAction) milestoneSelected:(id)sender;
- (IBAction) userSelected:(id)sender;
- (IBAction) projectSelected:(id)sender;

- (void) getProjectsTickets;
- (void) getProjects;
- (void) getMilestones;
- (void) getUsers;

-(IBAction) addServer:(id)sender;
- (void) getCachedServers;
- (void) networkErrorSheet:(NSString *) errorString;

- (NSString*) addressAt:(NSString*) postfix;
- (void) createEntitiesWithXML:(NSString *) xml toArrayController:(NSArrayController*)controller;

- (void) createNewTicket: (Ticket *)ticket;
- (void) resolveTicket: (Ticket *)ticket;
- (void) invalidateTicket: (Ticket *)ticket;
- (void) updateTicket:(Ticket *)ticket withXML:(NSString*)XML;

// remove em when ypu're not coding past midnight
- (NSString *) pathForDataFile;
@end
