//
//  GitHubIssuesMixer.m
//  Tickifier
//
//  Created by orta on 19/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "GitHubIssuesMixer.h"


@implementation GitHubIssuesMixer
@synthesize server, controller;

- (void) getTickets{
  NSLog(@"get tickets!");
}

- (void) getProjects{
  NSLog(@"get projects!");

}

- (void) getMilestones{
  NSLog(@"get milestones!");

}

- (void) getUsers{
  NSLog(@"get users!");

}

- (void) createNewTicket: (Ticket *)ticket{
  
}
- (void) resolveTicket: (Ticket *)ticket{
  
}
- (void) invalidateTicket: (Ticket *)ticket{
  
}

@end
