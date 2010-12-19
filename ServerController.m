//
//  LighthouseController.m
//  Tickifier
//
//  Created by orta therox on 16/09/2010.
//  Copyright (c) 2010 http://www.ortatherox.com. All rights reserved.
//

#import "ServerController.h"
#import "Seriously.h"


@implementation ServerController

@synthesize currentProject, projects, currentMilestone, milestones, currentAssignedToUser, users, currentTicket;
@synthesize currentServer, serverIndex, projectIndex, milestoneIndex, assignedToUserIndex, tickets;
@synthesize status, mixer, growlController;

- (void)awakeFromNib {
  [self getCachedServers];
  
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
	[projects setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	[milestones setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	[users setSortDescriptors:[NSArray arrayWithObject:descriptor]];
  
  self.currentTicket = [[Ticket alloc] init];
  self.growlController = [[GrowlController alloc] init];
}

-(void) setServerIndex:(NSInteger)index {
  [self bindToCurrentServer:NO];
  [self willChangeValueForKey:@"selectedIndices"];
  self.currentServer = [[servers content] objectAtIndex:index];
  serverIndex = index;
  [[NSUserDefaults standardUserDefaults] setObject:self.currentServer.url forKey:@"currentURL"];
  [self didChangeValueForKey:@"selectedIndices"];
  
  self.mixer = [self mixerFromServer:self.currentServer];
  
  NSLog(@"mixer : %@", self.mixer);
  if(self.currentServer.url && self.currentServer.APIKey){
    [self getProjects];    
    self.projectIndex = currentServer.projectIndex;
    self.milestoneIndex = currentServer.milestoneIndex;
    self.assignedToUserIndex = currentServer.userIndex;
  }
  
  [self bindToCurrentServer:YES];
}

- (void)setSelectedIndices:(NSIndexSet *)i {
  if([i count] ){
    [self setServerIndex:[i firstIndex]];    
  }

}
- (NSIndexSet *)getSelectedIndices {
  return [NSIndexSet indexSetWithIndex:serverIndex];
}

- (NSObject *) mixerFromServer:(Server *) mixerServer{
  Class MixerClass = NSClassFromString([self.currentServer.mixer stringByAppendingString:@"Mixer"]);
  NSObject <Mixer> *newMixer = [[MixerClass alloc] init];
  [newMixer setController: self];
  [newMixer setServer: mixerServer];
  return newMixer;
}

- (void) bindToCurrentServer:(BOOL)bind{
  if(bind){
    [self.currentServer bind:@"projectIndex" toObject:self withKeyPath:@"projectIndex" options:nil];
    [self.currentServer bind:@"milestoneIndex" toObject:self withKeyPath:@"milestoneIndex" options:nil];
    [self.currentServer bind:@"userIndex" toObject:self withKeyPath:@"assignedToUserIndex" options:nil];    
  }else{
    [self.currentServer unbind:@"projectIndex"];
    [self.currentServer unbind:@"milestoneIndex"];
    [self.currentServer unbind:@"userIndex"];
    
  }
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
    // These are things to trigger saves from
    [server addObserver:self forKeyPath:@"self.url" options:0 context:@""];
    [server addObserver:self forKeyPath:@"self.APIKey" options:0 context:@""];
    [server addObserver:self forKeyPath:@"self.projectIndex" options:0 context:@""];
    [server addObserver:self forKeyPath:@"self.milestoneIndex" options:0 context:@""];
    [server addObserver:self forKeyPath:@"self.userIndex" options:0 context:@""];
  }

  int i = 0;
  NSString * currentURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentURL"];
  for (Server *server in [servers content]) {
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

// called when the newServer's url/APIkey change
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  Server *server = (Server*) object;
  if([server.url rangeOfString:@"github"].location != NSNotFound){
    server.mixer = @"GitHubIssues";
    NSLog(@"hubby");
  }
  NSLog(@"looking at object %@", object);

  [self saveServerData];
}

- (void) saveServerData {
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


- (void) networkErrorSheet:(NSString *) errorString{
  NSAlert *alert = [[[NSAlert alloc] init] autorelease];
  [alert addButtonWithTitle:@"OK"];
  [alert setMessageText:[NSString stringWithFormat:@"Network Error : %@", errorString]];
  [alert setInformativeText:@"Oh noes! This is a problem, you're probably offline. Better to wait."];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert beginSheetModalForWindow:ticketWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction) refresh:(id)sender {
  [mixer getTickets]; 
}

- (void) getProjects {
  [mixer getProjects];  
}


- (void) getMilestones {
  [mixer getMilestones];
 }

- (void) getUsers {
  [mixer getUsers];
}

// this would break the get/setters if the naming convetion stayed
- (void) getProjectsTickets {
  [mixer getTickets];
}

- (IBAction) submit:(id)sender {
  [self createNewTicket:currentTicket]; 
}

- (void) resolveTicket: (Ticket *)ticket {
  [mixer resolveTicket:ticket];
}

- (void) invalidateTicket: (Ticket *)ticket {
  [mixer invalidateTicket:ticket];
}

-(void) createNewTicket: (Ticket *)ticket {
  [mixer createNewTicket:ticket];
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
