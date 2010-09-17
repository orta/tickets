//
//  LighthouseController.h
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LighthouseEntity.h"

@interface LighthouseController : NSObject {
  
  IBOutlet NSTextField * passwordField;
  NSString *serverAddress;
  NSString *APIKey;
  
  LighthouseEntity *currentProject;
  LighthouseEntity *currentMilestone;
  LighthouseEntity *currentUser;
  
  IBOutlet NSArrayController *projects;
  IBOutlet NSArrayController *milestones;
  IBOutlet NSArrayController *users;
  
  NSInteger projectIndex;
  NSInteger milestoneIndex;
  NSInteger userIndex;
}

@property (retain) NSString *APIKey;
@property (retain) NSString *serverAddress;

@property (retain) NSArrayController *projects;
@property (retain) NSArrayController *milestones;
@property (retain) NSArrayController *users;

@property (retain) LighthouseEntity *currentProject;
@property (retain) LighthouseEntity *currentMilestone;
@property (retain) LighthouseEntity *currentUser;

@property () NSInteger projectIndex;
@property () NSInteger milestoneIndex;
@property () NSInteger userIndex;
- (IBAction) userSelected:(id)sender;

- (IBAction) connect:(id)sender;
- (IBAction) milestoneSelected:(id)sender;


- (IBAction) projectSelected:(id)sender;


- (void) getProjects;
- (void) getMilestones;
- (void) getUsers;

- (NSString*) addressAt:(NSString*) postfix;
- (void) createEntitiesWithXML:(NSString *) xml toArrayController:(NSArrayController*)controller;


@end
