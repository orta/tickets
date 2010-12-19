//
//  GitHubIssuesMixer.h
//  Tickifier
//
//  Created by orta on 19/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Mixer_Protocol.h"

@class Server, ServerController;

@interface GitHubIssuesMixer : NSObject <Mixer> {

  Server * server;
  ServerController * controller; 
}

@property (retain) Server * server;
@property (retain) ServerController * controller; 

@end
