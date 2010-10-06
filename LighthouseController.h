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
#import "ORCycleTextField.h"

@interface LighthouseController : NSObject {
  
  IBOutlet NSTextField * passwordField;
  NSString *serverAddress;
  NSString *APIKey;
  
  LighthouseEntity *currentProject;
  LighthouseEntity *currentMilestone;
  LighthouseEntity *currentUser;
  
  Ticket *currentTicket;
  
  IBOutlet NSArrayController *projects;
  IBOutlet NSArrayController *milestones;
  IBOutlet NSArrayController *users;
  NSInteger projectIndex;
  NSInteger milestoneIndex;
  NSInteger userIndex;
  //
  
  
	NSMutableData *payload;
}

@property (retain) NSString *APIKey;
@property (retain) NSString *serverAddress;

@property (retain) NSArrayController *projects;
@property (retain) NSArrayController *milestones;
@property (retain) NSArrayController *users;

@property (retain) Ticket *currentTicket;

@property (retain) LighthouseEntity *currentProject;
@property (retain) LighthouseEntity *currentMilestone;
@property (retain) LighthouseEntity *currentUser;

@property () NSInteger projectIndex;
@property () NSInteger milestoneIndex;
@property () NSInteger userIndex;

- (IBAction) submit:(id)sender;
- (IBAction) milestoneSelected:(id)sender;
- (IBAction) userSelected:(id)sender;
- (IBAction) projectSelected:(id)sender;


- (void) getProjects;
- (void) getMilestones;
- (void) getUsers;

- (NSString*) addressAt:(NSString*) postfix;
- (void) createEntitiesWithXML:(NSString *) xml toArrayController:(NSArrayController*)controller;
- (void) submitTicket: (Ticket *)ticket;
- (void) currentProjectUserMileStoneArray;


@end
