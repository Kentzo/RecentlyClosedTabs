//
//  RCTRecentlyClosedTabsWindowContoller.h
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 16.02.10.
//  Copyright 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class RCTClosedTab;

@interface RCTRecentlyClosedTabsWindowContoller : NSWindowController <NSTableViewDataSource> {
	NSMutableArray* closedTabs;
	IBOutlet NSArrayController* closedTabsController;
	IBOutlet NSTableView* tableView;
}
@property (copy) NSMutableArray* closedTabs;
@property (retain) NSArrayController* closedTabsController;
@property (retain) NSTableView* tableView;
@property (copy) NSString* filterString;

- (void)addClosedTab:(RCTClosedTab*)closedTab;
- (void)tableDoubleClick:(id)sender;

@end
