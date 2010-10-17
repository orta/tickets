//
//  LighthouseMixer.m
//  Tickifier
//
//  Created by orta on 17/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "LighthouseMixer.h"
#import "Server.h"
#import "ServerController.h"
#import "Seriously.h"

@implementation LighthouseMixer
@synthesize server, controller;



- (NSString*) addressAt:(NSString*) postfix {
  return [NSString stringWithFormat:@"http://%@/%@?_token=%@", self.server.url, postfix, self.server.APIKey]; 
}

- (void) getProjects {
  NSString *url = [self addressAt:@"projects.xml"];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [controller networkErrorSheet:[error localizedDescription]];
    }
    else {
      [self createEntitiesWithXML:body toArrayController: controller.projects];
      
      if([[controller.projects content] count]){
        controller.projectIndex = self.server.projectIndex;
        if(controller.projectIndex > [[controller.projects content] count]) controller.projectIndex = 0;
        
        controller.currentProject = [[controller.projects arrangedObjects] objectAtIndex:controller.projectIndex];  
        [self getTickets];
        
        [self getUsers];
        [self getMilestones];
        
      }else{
        NSLog(@"No project selected");
      }
    }
  }];
}


- (void) getMilestones {
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/milestones.xml", controller.currentProject.identifier]];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [controller networkErrorSheet: [error localizedDescription] ];
    }
    else {
      [self createEntitiesWithXML:body toArrayController: controller.milestones];
      LighthouseEntity *noMilestone = [[LighthouseEntity alloc] init];
      noMilestone.name = @"No Milestone";
      noMilestone.identifier = @"999999999";
      [controller.milestones insertObject: noMilestone atArrangedObjectIndex:0];
      
      controller.assignedToUserIndex = server.milestoneIndex;
      controller.currentMilestone = [[controller.milestones arrangedObjects] objectAtIndex: server.milestoneIndex];       
    }
  }];  
}

- (void) getUsers {
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/memberships.xml", controller.currentProject.identifier]];
  
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [controller networkErrorSheet:[error localizedDescription]];
    }
    else {
      [self createEntitiesWithXML:body toArrayController:controller.users];
      
      if ( server ) {
        controller.assignedToUserIndex = server.userIndex;
        controller.currentAssignedToUser = [[controller.users arrangedObjects] objectAtIndex: server.userIndex ];
      }
    }
  }];  
}

// this would break the get/setters if the naming convetion stayed
- (void) getTickets {
  NSString *url = [NSString stringWithFormat:@"http://%@/projects/%@/tickets.xml?q=state:open responsible:me&_token=%@", self.server.url, controller.currentProject.identifier , controller.currentServer.APIKey]; 
  url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [controller networkErrorSheet:[error localizedDescription]];
    }
    else {
      NSXMLDocument * doc = [[NSXMLDocument alloc] initWithXMLString:body options:0 error:&error];
      NSArray *children = [[doc rootElement] children];
      NSMutableArray * tempTickets = [NSMutableArray array];
      int i, count = [children count];
      for (i=0; i < count; i++) { 
        NSXMLElement *ticketXML = [children objectAtIndex:i];
        Ticket *t = [Ticket ticketWithXMLElement:ticketXML];
        [tempTickets addObject:t];
      }        
      [controller.tickets setContent:tempTickets];
    }
  }];
}

- (void) createEntitiesWithXML:(NSString *) xml toArrayController:(NSArrayController*)arrayController {
  NSMutableArray *tempMembers = [NSMutableArray array];
  NSError *error;
  NSXMLDocument * doc = [[NSXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
  NSArray *children = [[doc rootElement] children];
  int i, count = [children count];
  for (i=0; i < count; i++) {
    
    NSXMLElement *membersElement = [children objectAtIndex:i];
    LighthouseEntity *newEntity = [[LighthouseEntity alloc] init];
    newEntity.identifier = [[[membersElement elementsForName:@"id"] objectAtIndex:0] stringValue] ;
    
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
      newEntity.identifier = [[[membersElement elementsForName:@"user-id"] objectAtIndex:0] stringValue] ;
      newEntity.name = [[[[membersElement elementsForName:@"user"] objectAtIndex:0] childAtIndex:2] stringValue];
    }
    
    // Dupe code
    BOOL found= NO;
    for (LighthouseEntity *entity in tempMembers) {
      if ([entity.name isEqualToString: newEntity.name]) {
        found = YES;
        break;
      }
    }
    
    if(!found){   
      // NSLog(@"created : %@ - %@", newEntity.name, newEntity.identifier);
      [tempMembers addObject:newEntity];
    }
  }
  
  [arrayController setContent:tempMembers];
}

- (void) resolveTicket: (Ticket *)ticket {
  NSString *XML = @"<ticket><state>resolved</state></ticket>";
  [self updateTicket:ticket withXML:XML];
}

- (void) invalidateTicket: (Ticket *)ticket {
  NSString *XML = @"<ticket><state>invalid</state></ticket>";
  [self updateTicket:ticket withXML:XML];
}

- (void) updateTicket:(Ticket *)ticket withXML:(NSString*)XML{
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/tickets/%@.xml", controller.currentProject.identifier, ticket.identifier]];
  
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  [urlRequest setHTTPMethod:@"PUT"];
  [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
  [urlRequest setHTTPBody:[XML dataUsingEncoding:NSUTF8StringEncoding]];
  
  [Seriously request:urlRequest options:nil handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [controller networkErrorSheet:[error localizedDescription]];
    }else{
      [self getTickets];
    }
  }];  
  
}

-(void) createNewTicket: (Ticket *)ticket {
  
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/tickets.xml", controller.currentProject.identifier]];
  
  NSString *milestoneString = @"";
  if(![controller.currentMilestone.identifier isEqualToString:@"999999999"]){
    milestoneString = [NSString stringWithFormat:@"<milestone-id>%@</milestone-id>", controller.currentMilestone.identifier];
  }
  
  NSString *XML = [NSString stringWithFormat:@"<ticket><title>%@</title><body>%@</body><tag>%@</tag>%@<assigned-user-id>%@</assigned-user-id></ticket>", 
                   ticket.title, ticket.body, ticket.tags, milestoneString, controller.currentAssignedToUser.identifier];
  
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
  [urlRequest setHTTPBody:[XML dataUsingEncoding:NSUTF8StringEncoding]];
  
  [Seriously request:urlRequest options:nil handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [controller networkErrorSheet:[error localizedDescription]];
    }else{
      //   NSString *content = [NSString stringWithUTF8String:[payload bytes]];
      controller.currentTicket.body = @"";
      controller.currentTicket.tags = @"";
      controller.currentTicket.title= @"";
      [self getTickets];
    }
  }];  
}


@end
