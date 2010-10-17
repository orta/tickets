//
//  LighthouseController.h
//  Tickifier
//
//  Created by orta therox on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LighthouseEntity.h"
#import "Ticket.h"
#import "Server.h"
#import "Mixer_Protocol.h"

@interface ServerController : NSObject {
  
  IBOutlet NSWindow *ticketWindow;
  IBOutlet NSTextField * passwordField;
  
  Server *currentServer;
  
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
  NSInteger serverIndex;
  
  NSString *status;
  
	NSMutableData *payload;
  
  NSObject <Mixer> *mixer;
}

@property (retain) NSArrayController *projects;
@property (retain) NSArrayController *milestones;
@property (retain) NSArrayController *users;
@property (retain) NSArrayController *tickets;

@property (retain) Ticket *currentTicket;

@property (retain) LighthouseEntity *currentProject;
@property (retain) LighthouseEntity *currentMilestone;
@property (retain) LighthouseEntity *currentAssignedToUser;

@property (retain) Server *currentServer;

@property () NSInteger projectIndex;
@property () NSInteger milestoneIndex;
@property () NSInteger assignedToUserIndex;
@property () NSInteger serverIndex;

@property (retain) NSString *status;

@property (retain) NSObject <Mixer> *mixer;

- (IBAction) submit:(id)sender;
- (IBAction) milestoneSelected:(id)sender;
- (IBAction) userSelected:(id)sender;
- (IBAction) projectSelected:(id)sender;
- (IBAction) refresh:(id)sender;

- (void) getProjectsTickets;
- (void) getProjects;
- (void) getMilestones;
- (void) getUsers;

-(IBAction) addServer:(id)sender;
- (void) getCachedServers;

- (void) networkErrorSheet:(NSString *) errorString;
- (void) createNewTicket: (Ticket *)ticket;
- (void) resolveTicket: (Ticket *)ticket;
- (void) invalidateTicket: (Ticket *)ticket;
- (void) updateTicket:(Ticket *)ticket withXML:(NSString*)XML;

- (void) saveServerData;

// remove em when ypu're not coding past midnight
- (NSString *) pathForDataFile;
- (IBAction)tableViewSelected:(id)sender;


- (void) bindToCurrentServer:(BOOL)bind;
- (NSObject *) mixerFromServer:(Server *) mixerServer;

@end
