//
//  SWMPluginController.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMPluginController.h"
#import "NSDictionary+WindowObject.h"
#import "NSDictionary+TabObject.h"
#import "DumpedSafariHeaders.h"
#import "SWMNotifications.h"


//static const NSUInteger kWindowsTabsHistoryDefaultCapacity = 5;

@implementation SWMPluginController

@synthesize windowsHistory;

- (id)init {
	if (self = [super init]) {
		windowsHistory = [NSMutableArray new];
	}
	return self;
}
- (void)dealloc {
	[windowsHistory release];
	[super dealloc];
}

- (void)safariWindowWillClose:(NSNotification *)notification {
	if ([[notification object] class] == NSClassFromString(@"BrowserWindow")) {
		BrowserWindow* closingWindow = [notification object];
		NSArray* closingWindowTabs = [(BrowserWindowController*)[closingWindow windowController] orderedTabs];
		
		// Collect all tabs
		NSUInteger currentTabNumber = 0;
		NSMutableArray* windowTabsHistory = [NSMutableArray arrayWithCapacity:[closingWindowTabs count]];
		for (BrowserWebView* tab in closingWindowTabs) {
			id title = [tab currentTitle];
			id url = [tab currentURL];
			if (title != nil && url != nil)
				[windowTabsHistory addObject:[NSDictionary tabWithTitle:title url:url]];
		}
		
		// Locate number of currentTab. If current tab isn't found, will store NSNotFound value
		BrowserWebView* currentTab = [(BrowserTabViewItem*)[closingWindow currentTabViewItem] webView];
		NSDictionary* windowObject = [NSDictionary windowObjectWithTabs:windowTabsHistory 
																   rect:[closingWindow frame] 
																  level:[closingWindow level] 
															 currentTab:[windowTabsHistory indexOfObject:currentTab]];
		[self.windowsHistory insertObject:windowObject atIndex:0];
		
		// Remove window tabs history
		// [windowsTabsHistory removeObjectForKey:closingWindow];
	}
}

@end
