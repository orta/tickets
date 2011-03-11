//
//  TicketsViewController.m
//  Tickifier
//
//  Created by orta on 04/12/2010.
//  Copyright 2010 http://www.ortatherox.com. All rights reserved.
//

#import "TicketsViewController.h"


@implementation TicketsViewController

- (id) init {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTickets:) name:@"TicketsUpdated" object:nil];
  self = [super init];
  return self;
}

- (void) reloadTickets: (NSNotification *) notification {
  NSLog(@"wow, TV sucks");
  [listView reloadDataAnimated:true];
}


#pragma mark JAListViewDelegate

- (void)listView:(JAListView *)list willSelectView:(JAListViewItem *)view {
  if(list == self.listView) {
    TicketItemView *demoView = (TicketItemView *) view;
    demoView.selected = YES;
  }
}

- (void)listView:(JAListView *)list didSelectView:(JAListViewItem *)view {
  if(list == self.listView) {
    TicketItemView *demoView = (TicketItemView *) view;
    demoView.selected = NO;
  }
  [list reloadDataAnimated:YES];
}

- (void)listView:(JAListView *)list didUnSelectView:(JAListViewItem *)view {
  if(list == self.listView) {
    TicketItemView *demoView = (TicketItemView *) view;
    demoView.selected = NO;
  }
}


#pragma mark JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
  return [[tickets content] count];
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
  Ticket * currentTicket = [[tickets arrangedObjects] objectAtIndex:index];
  TicketItemView *view = [TicketItemView ticketItemViewWithTicket:currentTicket];
  return view;
}

@synthesize listView;

@end
