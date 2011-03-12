//
//  TicketsViewController.h
//  Tickifier
//
//  Created by orta on 04/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JAListView.h"
#import "JASectionedListView.h"
#import "TicketItemView.h"

@interface TicketsViewController : NSObject <JAListViewDataSource, JAListViewDelegate>{

  IBOutlet NSArrayController * tickets;
  JAListView *listView;
  NSArray * views;

}
@property (assign) IBOutlet JAListView *listView;

@end
