//
//  Ticket.h
//  Tickifier
//
//  Created by orta therox on 16/09/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Ticket : NSObject {
  NSString * title;
  NSString *body;
  NSString *tags;
  NSString *identifier;
  NSString *url;
}

@property (retain) NSString * title;
@property (retain) NSString *body;
@property (retain) NSString *tags;
@property (retain) NSString *identifier;
@property (retain) NSString *url;

+ (Ticket *) ticketWithXMLElement: (NSXMLElement *) element;
@end
