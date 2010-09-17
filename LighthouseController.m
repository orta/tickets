//
//  LighthouseController.m
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import "LighthouseController.h"
#import "Seriously.h"

@implementation LighthouseController

@synthesize serverAddress, APIKey;

@synthesize currentProject, projects, currentMilestone, milestones, currentUser, users;

- (void)awakeFromNib {
  
  [self bind:@"serverAddress"
    toObject:[NSUserDefaultsController sharedUserDefaultsController]
 withKeyPath:@"values.server_address"
     options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                         forKey:@"NSContinuouslyUpdatesValue"]];
  
  [self bind:@"APIKey"
    toObject:[NSUserDefaultsController sharedUserDefaultsController]
 withKeyPath:@"values.api_key"
     options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                         forKey:@"NSContinuouslyUpdatesValue"]];
  

  if (self.serverAddress && self.APIKey) {    
    [self getProjects];
  }
}

- (NSString*) addressAt:(NSString*) postfix {
  return [NSString stringWithFormat:@"http://%@/%@?_token=%@", self.serverAddress, postfix, self.APIKey]; 
}

- (IBAction) projectSelected:(id)sender {
  self.currentProject = [[projects content] objectAtIndex:[sender indexOfSelectedItem]];
  [self getMilestones];
}

- (void) getMilestones {
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%i/milestones.xml", self.currentProject.identifier]];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    }
    else {
      NSLog(@"%@", body);
      [self createEntitiesWithXML:body toArrayController:milestones];
    }
  }];  
}

- (void) getProjects {
  NSString *url = [self addressAt:@"projects.xml"];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    }
    else {
      NSLog(@"%@", body);
      [self createEntitiesWithXML:body toArrayController:projects];
    }
  }];  
}

- (void) createEntitiesWithXML:(NSString *) xml toArrayController:(NSArrayController*)controller {
  NSMutableArray *tempMembers = [NSMutableArray array];
  NSError *error;
  NSXMLDocument * doc = [[NSXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
  NSArray *children = [[doc rootElement] children];
  int i, count = [children count];
  for (i=0; i < count; i++) {
    
    NSXMLElement *membersElement = [children objectAtIndex:i];
    LighthouseEntity *newProject = [[LighthouseEntity alloc] init];
    newProject.identifier = [[[[membersElement elementsForName:@"id"] objectAtIndex:0] stringValue] integerValue];
    if([[membersElement elementsForName:@"name"] count] > 0){
      newProject.name = [[[membersElement elementsForName:@"name"] objectAtIndex:0] stringValue];  
    }else{
      newProject.name = [[[membersElement elementsForName:@"title"] objectAtIndex:0] stringValue];
    }
    
    [tempMembers addObject:newProject];
  }
  [controller setContent:tempMembers];
}


- (IBAction)connect:(id)sender {
  
}

- (void)dealloc {
    [super dealloc];
}

@end
