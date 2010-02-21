//
//  SWMRecentClosedTabsWindowContoller.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class SWMClosedTab;

@interface SWMRecentlyClosedTabsWindowContoller : NSWindowController <NSTableViewDataSource> {
	NSMutableArray* closedTabs;
	IBOutlet NSArrayController* closedTabsController;
	IBOutlet NSTableView* tableView;
}
@property (copy) NSMutableArray* closedTabs;
@property (retain) NSArrayController* closedTabsController;
@property (retain) NSTableView* tableView;
@property (copy) NSString* filterString;

- (void)addClosedTab:(SWMClosedTab*)closedTab;
- (void)tableDoubleClick:(id)sender;

@end
