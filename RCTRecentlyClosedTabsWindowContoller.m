//
//  RCTRecentlyClosedTabsWindowContoller.m
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 16.02.10.
//  Copyright 2010. All rights reserved.
//

#import "RCTRecentlyClosedTabsWindowContoller.h"
#import "RCTClosedTab.h"
#import "DumpedSafariHeaders.h"
#import "NSArray+CWSortedInsert.h"


@interface RCTRecentlyClosedTabsWindowContoller (Private)
- (void)goToURL:(NSURL*)url;
@end

@implementation RCTRecentlyClosedTabsWindowContoller
@synthesize closedTabs;
@synthesize closedTabsController;
@synthesize tableView;
@dynamic filterString;

- init {
	if (self = [super init]) {
		closedTabs = [[NSMutableArray alloc] initWithCapacity:50];
		NSBundle* pluginBundle = [NSBundle bundleForClass:[self class]];
		NSNib* recentClosedTabsWindow = [[NSNib alloc] initWithNibNamed:@"RecentlyClosedTabsWindow" bundle:pluginBundle];
		[recentClosedTabsWindow instantiateNibWithOwner:self topLevelObjects:nil];
		[recentClosedTabsWindow release];
		[tableView setDoubleAction:@selector(tableDoubleClick:)];
		[tableView setTarget:self];
		// if no sort descriptors are set, will add them
		if (![[tableView sortDescriptors] count]) {
			NSLog(@"RCT: No descriptors found. Set to default.");
            NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"closingTime" ascending:NO]];
			[tableView setSortDescriptors:sortDescriptors];
			[tableView setIndicatorImage:[NSImage imageNamed:@"NSDescendingSortIndicator"]
                           inTableColumn:[tableView tableColumnWithIdentifier:@"Date"]];
		}
	}
	return self;
}

- (void)dealloc {
	[closedTabs release];
	[closedTabsController release];
    [tableView release];
	[super dealloc];
}

- (void)setFilterString:(NSString *)newFilter {
	if (newFilter != nil) {
		NSPredicate* filter = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@) || (url.absoluteString CONTAINS[cd] %@)", newFilter, newFilter];
		[closedTabsController setFilterPredicate:filter];
	}
	else {
		[closedTabsController setFilterPredicate:nil];
	}
    
}

- (NSString*)filterString {
	return [[closedTabsController filterPredicate] predicateFormat];
}

- (void)addClosedTab:(RCTClosedTab*)closedTab {
	[closedTabsController removeObject:closedTab];
    NSMutableArray* contentProxy = [self mutableArrayValueForKey:@"closedTabs"];
    [contentProxy insertObject:closedTab sortedUsingDescriptors:[closedTabsController sortDescriptors]];
}
- (void)tableDoubleClick:(id)sender {
	NSUInteger index = [sender clickedRow];
	if (index != -1) {
        NSURL* clickedRowURL = [closedTabsController valueForKeyPath:@"selection.url"];
        [self goToURL:clickedRowURL];
	}
}
- (void)keyDown:(NSEvent *)theEvent {
	if ([theEvent keyCode] == 36 && [closedTabs count]) { // Enter was pushed
		NSURL* clickedRowURL = [closedTabsController valueForKeyPath:@"selection.url"];
        [self goToURL:clickedRowURL];
	}
	else {
		[super keyDown:theEvent];
	}
}

@end
                                    
@implementation RCTRecentlyClosedTabsWindowContoller (Private)
- (void)goToURL:(NSURL*)url {
    BrowserDocumentController* documentController = [NSClassFromString(@"BrowserDocumentController") sharedDocumentController];
    [documentController goToURL:url windowPolicy:NewTabWindowPolicy];
}

@end

