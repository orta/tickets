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

- (void) awakeFromNib {
  [listView setBackgroundColor:[NSColor colorWithDeviceWhite:1.0f alpha:255]];
}

- (void) reloadTickets: (NSNotification *) notification {
  NSMutableArray *spareViewArray = [NSMutableArray array];
  for (Ticket* t in [tickets arrangedObjects]) {
    TicketItemView *view = [TicketItemView ticketItemViewWithTicket:t];    
    [spareViewArray addObject:view];
  }
  views = spareViewArray;
  
  [listView reloadDataAnimated:YES];
}


#pragma mark JAListViewDelegate

- (void)listView:(JAListView *)list willSelectView:(JAListViewItem *)view {
  if(list == self.listView) {
    TicketItemView *currentView = (TicketItemView *) view;   
    currentView.pressed = YES;
  }
}

- (void)listView:(JAListView *)list didSelectView:(JAListViewItem *)view {
  if(list == self.listView) {
    TicketItemView *currentView = (TicketItemView *) view;
    currentView.pressed = NO;
    currentView.selected = YES;
  }
  [listView reloadLayoutAnimated:NO];
}

- (void)listView:(JAListView *)list didUnSelectView:(JAListViewItem *)view {
  if(list == self.listView) {
    TicketItemView *currentView = (TicketItemView *) view;
    currentView.selected = NO;
  }
  [listView reloadLayoutAnimated:NO];

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
