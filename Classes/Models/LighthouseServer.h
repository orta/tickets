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
}
@property (retain) NSString *url;
@property (retain) NSString *APIKey;

- (id) copyWithZone:(NSZone *)aZone;

@end
