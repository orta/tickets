//
//  LighthouseMixer.h
//  Tickifier
//
//  Created by orta on 17/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Mixer_Protocol.h"

@class Server;
@class ServerController;

@interface LighthouseMixer : NSObject <Mixer> {
  Server * server;
  ServerController * controller; 
}

- (void) createEntitiesWithXML:(NSString *) xml toArrayController:(NSArrayController*)controller;
- (void) updateTicket:(Ticket *)ticket withXML:(NSString*)XML;

@property (retain) Server * server;
@property (retain) ServerController * controller; 
@end
