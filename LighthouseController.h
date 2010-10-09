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

@interface LighthouseController : NSObject {
  
  IBOutlet NSWindow *ticketWindow;
  IBOutlet NSTextField * passwordField;
  NSString *serverAddress;
  NSString *APIKey;
  
  LighthouseEntity *currentProject;
  LighthouseEntity *currentMilestone;
  LighthouseEntity *currentAssignedToUser;

  Ticket *currentTicket;
  
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

@property (retain) NSString *APIKey;
@property (retain) NSString *serverAddress;

@property (retain) NSArrayController *projects;
@property (retain) NSArrayController *milestones;
@property (retain) NSArrayController *users;
@property (retain) NSArrayController *tickets;


@property (retain) Ticket *currentTicket;

@property (retain) LighthouseEntity *currentProject;
@property (retain) LighthouseEntity *currentMilestone;
@property (retain) LighthouseEntity *currentAssignedToUser;


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

- (void) networkErrorSheet:(NSString *) errorString;


- (NSString*) addressAt:(NSString*) postfix;
- (void) createEntitiesWithXML:(NSString *) xml toArrayController:(NSArrayController*)controller;
- (void) submitTicket: (Ticket *)ticket;

@end
