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

@synthesize currentProject, projects, currentMilestone, milestones, currentUser, users, currentTicket;
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
  
  self.currentTicket = [[Ticket alloc] init];
}

- (NSString*) addressAt:(NSString*) postfix {
  return [NSString stringWithFormat:@"http://%@/%@?_token=%@", self.serverAddress, postfix, self.APIKey]; 
}

- (IBAction) projectSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"projectIndex"];
  self.currentProject = [[projects content] objectAtIndex:[sender indexOfSelectedItem]];

  [self getMilestones];
  [self getUsers];
  [self currentProjectUserMileStoneArray];

}

- (IBAction) milestoneSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"milestoneIndex"];
  self.currentMilestone = [[milestones content] objectAtIndex:  [[[NSUserDefaults standardUserDefaults] objectForKey:@"milestoneIndex"] integerValue]];
  [self currentProjectUserMileStoneArray];

}

- (IBAction) userSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"userIndex"];
  self.currentUser = [[users content] objectAtIndex:  [[[NSUserDefaults standardUserDefaults] objectForKey:@"userIndex"] integerValue]];
  [self currentProjectUserMileStoneArray];

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
        if([[self.projects content] count]){
          self.projectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"projectIndex"];
          self.currentProject = [[projects content] objectAtIndex:self.projectIndex];  
          
          [self getUsers];
          [self getMilestones];
          [self currentProjectUserMileStoneArray];

        }
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
        if([[self.milestones content] count]){
          self.milestoneIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"milestoneIndex"];
          self.currentMilestone = [[milestones content] objectAtIndex:  [[[NSUserDefaults standardUserDefaults] objectForKey:@"milestoneIndex"] integerValue]];        
        }else{
          self.currentMilestone = nil;
        }
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
        if([[self.users content] count]){

          self.userIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"userIndex"];
          self.currentUser = [[users content] objectAtIndex:  [[[NSUserDefaults standardUserDefaults] objectForKey:@"userIndex"] integerValue]];
        }
        else {
          self.currentUser = nil;
        }

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

- (IBAction) submit:(id)sender {
  [self submitTicket:currentTicket]; 
}

-(void) submitTicket: (Ticket *)ticket {
  
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%i/tickets.xml", self.currentProject.identifier]];
  
  NSMutableString *tags = [NSMutableString stringWithString:@""];
  for (NSString* tag in ticket.tags) {
    [tags appendString:tag];
  }
  
  NSString *XML = [NSString stringWithFormat:@"<ticket><title>%@</title><body>%@</body><tag>%@</tag><milestone-id>%i</milestone-id><assigned-user-id>%i</assigned-user-id></ticket>", 
                   ticket.title, ticket.body, tags, currentMilestone.identifier, currentUser.identifier];
  
  NSLog(@"XML %@", XML);
  NSLog(@"not sending to avoid spam");
  
  return;
  
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
  [urlRequest setHTTPBody:[XML dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSURLConnection *connectionResponse = [[NSURLConnection alloc]  initWithRequest:urlRequest delegate:self];

  if (!connectionResponse) {
    NSLog(@"Failed to submit request");
  } else {
    NSLog(@"Request submitted");
    payload = [[NSMutableData data] retain];
  }                           
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response {
   [payload setLength:0];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
   [payload appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
   NSString *content = [NSString stringWithUTF8String:[payload bytes]];
  currentTicket = [[Ticket alloc] init];
   NSLog(@"Connection finished: %@ - %@", conn, content);
}

 - (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
   
}

- (void) currentProjectUserMileStoneArray {
  NSMutableArray * strings = [NSMutableArray array];
  if (self.currentProject != nil) {
    [strings addObject:currentProject.name];
  }
  if (self.currentUser.name != nil) {
    [strings addObject:currentUser.name];
  }
  if (self.currentMilestone.name != nil) {
    [strings addObject:currentMilestone.name];
  }
  cycleTextField.strings = strings;
}

- (void)dealloc {
    [super dealloc];
}

@end
