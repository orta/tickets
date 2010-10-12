//
//  LighthouseServer.h
//  Tickifier
//
//  Created by orta on 12/10/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LighthouseServer : NSObject {
  NSString *url;
  NSString *APICode;
}
@property (retain) NSString *url;
@property (retain) NSString *APICode;
@end
