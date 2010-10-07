//
//  Ticket.h
//  Tickifier
//
//  Created by Ben Maslen on 16/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Ticket : NSObject {
  NSString * title;
  NSString *body;
  NSString *tags;
  NSString *identifier;
}

@property (retain) NSString * title;
@property (retain) NSString *body;
@property (retain) NSString *tags;
@property (retain) NSString *identifier;

@end
