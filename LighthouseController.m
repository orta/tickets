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
@synthesize projectIndex, milestoneIndex, userIndex;


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
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"projectIndex"];
  self.currentProject = [[projects content] objectAtIndex:[sender indexOfSelectedItem]];

  [self getMilestones];
  [self getUsers];
}

- (IBAction) milestoneSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"milestoneIndex"];
}

- (IBAction) userSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"userIndex"];
}


- (void) getProjects {
  NSString *url = [self addressAt:@"projects.xml"];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    }
    else {
      [self createEntitiesWithXML:body toArrayController:projects];
      
      if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"projectIndex"] integerValue] ) {
        self.projectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"projectIndex"];
        self.currentProject = [[projects content] objectAtIndex:self.projectIndex];
        
        [self getUsers];
        [self getMilestones];
      }
    }
  }];
}


- (void) getMilestones {
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%i/milestones.xml", self.currentProject.identifier]];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    }
    else {
      [self createEntitiesWithXML:body toArrayController:milestones];
      if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"milestoneIndex"] integerValue] ) {
        self.milestoneIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"milestoneIndex"];
      }
      
    }
  }];  
}

- (void) getUsers {
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%i/memberships.xml", self.currentProject.identifier]];

  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    }
    else {
      [self createEntitiesWithXML:body toArrayController:users];
      
      if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"userIndex"] integerValue] ) {
        self.userIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"userIndex"];
      }
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
    LighthouseEntity *newEntity = [[LighthouseEntity alloc] init];
    newEntity.identifier = [[[[membersElement elementsForName:@"id"] objectAtIndex:0] stringValue] integerValue];
    //Project
    if([[membersElement elementsForName:@"name"] count] > 0){
      newEntity.name = [[[membersElement elementsForName:@"name"] objectAtIndex:0] stringValue];  
    }
    //Milestone
    if([[membersElement elementsForName:@"title"] count] > 0){
      newEntity.name = [[[membersElement elementsForName:@"title"] objectAtIndex:0] stringValue];
    }
    //Users
    if([[membersElement elementsForName:@"user-id"] count] > 0){
      newEntity.identifier = [[[[membersElement elementsForName:@"user-id"] objectAtIndex:0] stringValue] integerValue];
      newEntity.name = [[[[membersElement elementsForName:@"user"] objectAtIndex:0] childAtIndex:2] stringValue];
    }
    NSLog(@"created : %@", newEntity);
    [tempMembers addObject:newEntity];
  }
  [controller setContent:tempMembers];
}


- (IBAction)connect:(id)sender {
  
}

- (void)dealloc {
    [super dealloc];
}

@end
