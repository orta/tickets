//
//  LighthouseServer.h
//  Tickifier
//
//  Created by orta on 12/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LighthouseServer : NSObject <NSCoding>{
  NSString *url;
  NSString *APIKey;
  
  int projectIndex;
  int milestoneIndex;
  int userIndex;
}

@property (retain) NSString *url;
@property (retain) NSString *APIKey;
@property () int projectIndex;
@property () int milestoneIndex;
@property () int userIndex;

@end
