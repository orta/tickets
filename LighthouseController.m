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

@synthesize currentProject, projects;

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
  

}

- (NSString*) addressAt:(NSString*) postfix {
  return [NSString stringWithFormat:@"http://%@/%@?_token=%@", self.serverAddress, postfix, self.APIKey]; 
}

- (IBAction) testCredentials:(id)sender {
  
  NSString *url = [self addressAt:@"projects.xml"];
  
  [Seriously get:url handler:^(id body, NSHTTPURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    }
    else {
      NSLog(@"%@", body);
      [self createProjectsWithXML:body];
    }
  }];
}

- (void) createProjectsWithXML:(NSString *) xml {
  NSMutableArray *tempProjects = [NSMutableArray array];
  
  NSError *error;
  NSXMLDocument * doc = [[NSXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
  NSArray *children = [[doc rootElement] children];
  int i, count = [children count];
  for (i=0; i < count; i++) {
    
    NSXMLElement *projectElement = [children objectAtIndex:i];
    Project *newProject = [[Project alloc] init];
    newProject.identifier = [[[[projectElement elementsForName:@"id"] objectAtIndex:0] stringValue] integerValue];
    newProject.name = [[[projectElement elementsForName:@"name"] objectAtIndex:0] stringValue];
    [tempProjects addObject:newProject];
  }
  [self.projects setContent:tempProjects];
}

- (IBAction)connect:(id)sender {
  
}

- (void)dealloc {
    [super dealloc];
}

@end
