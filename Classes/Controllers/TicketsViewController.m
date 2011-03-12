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
  NSMutableArray *spareViewArray = [NSMutableArray array];
  for (Ticket* t in [tickets arrangedObjects]) {
    TicketItemView *view = [TicketItemView ticketItemViewWithTicket:t];    
    [spareViewArray addObject:view];
  }
  views = spareViewArray;
  
  [listView reloadDataAnimated:true];
}


#pragma mark JAListViewDelegate

- (void)listView:(JAListView *)list willSelectView:(JAListViewItem *)view {
//  if(list == self.listView) {
//    TicketItemView *currentView = (TicketItemView *) view;
//  }
}

- (void)listView:(JAListView *)list didSelectView:(JAListViewItem *)view {
  NSLog(@"did selecr");
  if(list == self.listView) {
    TicketItemView *currentView = (TicketItemView *) view;
    currentView.selected = YES;
  }
  [list reloadDataAnimated:YES];
}

- (void)listView:(JAListView *)list didUnSelectView:(JAListViewItem *)view {
  if(list == self.listView) {
    TicketItemView *currentView = (TicketItemView *) view;
    currentView.selected = NO;
  }
}


#pragma mark JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
  return [[tickets content] count];
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
  return [views objectAtIndex:index];
}

@synthesize listView;

@end
