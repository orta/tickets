//
//  LighthouseController.h
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Project.h"

@interface LighthouseController : NSObject {
  
  IBOutlet NSTextField * passwordField;
  NSString *serverAddress;
  NSString *APIKey;
  
  Project *currentProject;
  IBOutlet NSArrayController *projects;
}

@property (retain) NSString *APIKey;
@property (retain) NSString *serverAddress;
@property (retain) NSArrayController *projects;
@property (retain) Project *currentProject;

- (IBAction) testCredentials:(id)sender;
- (IBAction)connect:(id)sender;
- (void) createProjectsWithXML:(NSString *) xml;

@end
