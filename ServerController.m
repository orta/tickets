//
//  LighthouseController.m
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import "ServerController.h"
#import "Seriously.h"

@implementation ServerController

@synthesize currentProject, projects, currentMilestone, milestones, currentAssignedToUser, users, currentTicket;
@synthesize currentServer, serverIndex, projectIndex, milestoneIndex, assignedToUserIndex, tickets;
@synthesize status;

- (void)awakeFromNib {
  [self getCachedServers];
  
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
	[projects setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	[milestones setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	[users setSortDescriptors:[NSArray arrayWithObject:descriptor]];
  
  self.currentTicket = [[Ticket alloc] init];
}

- (void) getCachedServers{
  // get our servers
  NSString * path = [self pathForDataFile];
  NSDictionary * rootObject;
  
  rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];    
  [servers setContent: [rootObject valueForKey:@"servers"]];
  if([servers content] == nil){
    [self addServer:self];
  }

  for (Server *server in [servers content]) {
    [server addObserver:self forKeyPath:@"self.url" options:0 context:@""];
    [server addObserver:self forKeyPath:@"self.APIKey" options:0 context:@""];
  }

  int i = 0;
  NSString * currentURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentURL"];
  NSLog(@"currentURL : %@", currentURL);
  for (Server *server in [servers content]) {
    NSLog(@"found server %@", server);
    if ([server.url isEqualToString: currentURL ]) {
      self.serverIndex = i;
      break;
    }
    i++;
  }  
}

-(IBAction) addServer:(id)sender {
  Server * newServer = [[Server alloc] init];
  newServer.url = @"example.lighthouseapp.com";
  [servers setContent:[[servers content] arrayByAddingObject:newServer]];
  self.currentServer = newServer;
  [newServer addObserver:self forKeyPath:@"self.url" options:0 context:@""];
  [newServer addObserver:self forKeyPath:@"self.APIKey" options:0 context:@""];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  NSString * path = [self pathForDataFile];
  
  NSMutableDictionary * rootObject;
  rootObject = [NSMutableDictionary dictionary];
  
  [rootObject setValue: [servers content] forKey:@"servers"];
  [NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}


- (NSString*) addressAt:(NSString*) postfix {
  return [NSString stringWithFormat:@"http://%@/%@?_token=%@", self.currentServer.url, postfix, self.currentServer.APIKey]; 
}

- (IBAction) projectSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"projectIndex"];
  [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"milestoneIndex"];

  self.currentProject = [[projects arrangedObjects] objectAtIndex:[sender indexOfSelectedItem]];
  [self getMilestones];
  [self getUsers];
  [self getProjectsTickets];
}

- (IBAction) milestoneSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"milestoneIndex"];
  self.currentMilestone = [[milestones arrangedObjects] objectAtIndex:  [[[NSUserDefaults standardUserDefaults] objectForKey:@"milestoneIndex"] integerValue]];

}

- (IBAction) userSelected:(id)sender {
  [[NSUserDefaults standardUserDefaults] setInteger: [sender indexOfSelectedItem] forKey:@"assignedToUserIndex"];
  self.currentAssignedToUser = [[users arrangedObjects] objectAtIndex:  [sender indexOfSelectedItem]];

}

- (void) getProjects {
  NSString *url = [self addressAt:@"projects.xml"];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [self networkErrorSheet:[error localizedDescription]];
    }
    else {
      [self createEntitiesWithXML:body toArrayController:projects];
      
      if([[self.projects content] count]){
        self.projectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"projectIndex"];
        self.currentProject = [[projects arrangedObjects] objectAtIndex:self.projectIndex];  
        
        [self getProjectsTickets];
        
        [self getUsers];
        [self getMilestones];
  
      }else{
        NSLog(@"No project selected");
      }
    }
  }];
}


- (void) getMilestones {
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/milestones.xml", self.currentProject.identifier]];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [self networkErrorSheet: [error localizedDescription] ];
    }
    else {
      [self createEntitiesWithXML:body toArrayController:milestones];
      LighthouseEntity *noMilestone = [[LighthouseEntity alloc] init];
      noMilestone.name = @"No Milestone";
      noMilestone.identifier = @"999999999";
      [milestones insertObject: noMilestone atArrangedObjectIndex:0];
      int index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"milestoneIndex"] integerValue];
      self.milestoneIndex = index;
      self.currentMilestone = [[milestones arrangedObjects] objectAtIndex: index];       
    }
  }];  
}

- (void) getUsers {
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/memberships.xml", self.currentProject.identifier]];

  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [self networkErrorSheet:[error localizedDescription]];
    }
    else {
      [self createEntitiesWithXML:body toArrayController:users];
      
      if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"assignedToUserIndex"] integerValue] ) {
        self.assignedToUserIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"assignedToUserIndex"];
        self.currentAssignedToUser = [[users arrangedObjects] objectAtIndex:  [[[NSUserDefaults standardUserDefaults] objectForKey:@"assignedToUserIndex"] integerValue]];
      }
    }
  }];  
}

// this would break the get/setters if the naming convetion stayed
- (void) getProjectsTickets {
  NSString *url = [NSString stringWithFormat:@"http://%@/projects/%@/tickets.xml?q=state:open responsible:me&_token=%@", self.currentServer.url, self.currentProject.identifier , self.currentServer.APIKey]; 
  url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [self networkErrorSheet:[error localizedDescription]];
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
      [tickets setContent:tempTickets];
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
  
  [controller setContent:tempMembers];
}

- (void) networkErrorSheet:(NSString *) errorString{
  NSAlert *alert = [[[NSAlert alloc] init] autorelease];
  [alert addButtonWithTitle:@"OK"];
  [alert setMessageText:[NSString stringWithFormat:@"Network Error : %@", errorString]];
  [alert setInformativeText:@"Oh noes! This is a problem, you're probably offline. Better to wait."];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert beginSheetModalForWindow:ticketWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction) submit:(id)sender {
  [self createNewTicket:currentTicket]; 
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
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/tickets/%@.xml", self.currentProject.identifier, ticket.identifier]];
  
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  [urlRequest setHTTPMethod:@"PUT"];
  [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
  [urlRequest setHTTPBody:[XML dataUsingEncoding:NSUTF8StringEncoding]];
  
  [Seriously request:urlRequest options:nil handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [self networkErrorSheet:[error localizedDescription]];
    }else{
      [self getProjectsTickets];
    }
  }];  
  
}

-(void) createNewTicket: (Ticket *)ticket {
  
  NSString *url = [self addressAt: [NSString stringWithFormat:@"projects/%@/tickets.xml", self.currentProject.identifier]];
  
  NSString *milestoneString = @"";
  if(![currentMilestone.identifier isEqualToString:@"999999999"]){
    milestoneString = [NSString stringWithFormat:@"<milestone-id>%@</milestone-id>", currentMilestone.identifier];
  }
  
  NSString *XML = [NSString stringWithFormat:@"<ticket><title>%@</title><body>%@</body><tag>%@</tag>%@<assigned-user-id>%@</assigned-user-id></ticket>", 
                   ticket.title, ticket.body, ticket.tags, milestoneString, currentAssignedToUser.identifier];
    
  NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
  [urlRequest setHTTPBody:[XML dataUsingEncoding:NSUTF8StringEncoding]];
  
  [Seriously request:urlRequest options:nil handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [self networkErrorSheet:[error localizedDescription]];
    }else{
   //   NSString *content = [NSString stringWithUTF8String:[payload bytes]];
      currentTicket.body = @"";
      currentTicket.tags = @"";
      currentTicket.title= @"";
      [self getProjectsTickets];
    }
  }];  
}

+ (NSSet *)keyPathsForValuesAffectingStatus {
  return [NSSet setWithObjects:@"currentAssignedToUser", @"currentMilestone", @"currentProject", nil];
}


- (NSString *) getStatus {
  NSString * milestone = self.currentMilestone.name;
  if(milestone == nil) milestone = @"no milestone";
  
  return [NSString stringWithFormat:@"Posting to %@, assigning to %@ on %@", self.currentProject.name, self.currentAssignedToUser.name, milestone];
}

- (IBAction)tableViewSelected:(id)sender {
  self.serverIndex = [sender selectedRow];

}


-(void) setServerIndex:(NSInteger)index {
  [self.currentServer unbind:@"projectIndex"];
  [self.currentServer unbind:@"milestoneIndex"];
  [self.currentServer unbind:@"userIndex"];
  
  self.currentServer = [[servers content] objectAtIndex:index];
  NSLog(@"setting server to %@", self.currentServer.url);
  serverIndex = index;
  [[NSUserDefaults standardUserDefaults] setObject:self.currentServer.url forKey:@"currentURL"];
  NSLog(@"Server: %@", self.currentServer);
  
  if(self.currentServer.url && self.currentServer.APIKey){
    [self getProjects];    
    self.projectIndex = currentServer.projectIndex;
    self.milestoneIndex = currentServer.milestoneIndex;
    self.assignedToUserIndex = currentServer.userIndex;
  }
  
  [self.currentServer bind:@"projectIndex" toObject:self withKeyPath:@"projectIndex" options:nil];
  [self.currentServer bind:@"milestoneIndex" toObject:self withKeyPath:@"milestoneIndex" options:nil];
  [self.currentServer bind:@"userIndex" toObject:self withKeyPath:@"assignedToUserIndex" options:nil];
  
}

- (NSString *) pathForDataFile {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  NSString *folder = @"~/Library/Application Support/tickets/";
  folder = [folder stringByExpandingTildeInPath];
  
  if ([fileManager fileExistsAtPath: folder] == NO) {
    NSError *error;
    [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
   }
  
  NSString *fileName = @"servers.plist";
  return [folder stringByAppendingPathComponent: fileName];    
}

@end
