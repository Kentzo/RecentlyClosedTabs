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


static SWMPluginController* g_sharedPluginContoller = nil;

@implementation SWMPluginController

@synthesize windowHistory;
@synthesize maxObjectsInWindowHistory;

#pragma mark Singleton
+ (SWMPluginController*)sharedInstance {
	@synchronized(self) {
		if (g_sharedPluginContoller == nil) {
			g_sharedPluginContoller = [SWMPluginController new];
		}
	}
	return g_sharedPluginContoller;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (g_sharedPluginContoller == nil) {
            g_sharedPluginContoller = [super allocWithZone:zone];
            return g_sharedPluginContoller;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}
- (void)release {
    //do nothing
}
- (id)autorelease {
    return self;
}

#pragma mark Methods
//+ (void)initialize {
//	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//	NSDictionary* defaultPreferences = [NSDictionary dictionaryWithObjectsAndKeys:
//										[NSNumber numberWithBool:NO], @"SWM.toolbarButtonShouldBeInserted",
//										[NSNumber numberWithUnsignedInteger:2], @"SWM.toolbarButtonIndex", nil];
//	[userDefaults registerDefaults:defaultPreferences];
//}

- (id)init {
	if (self = [super init]) {
		windowHistory = [[NSMutableArray alloc] initWithCapacity:maxObjectsInWindowHistory];
		toolbarButtonIdentifier = @"SWMToolbarButtonIdentifier";
		
		toolbarButton = [NSButton new];
		[toolbarButton setBezelStyle:NSTexturedRoundedBezelStyle];
		[toolbarButton setFrameSize:NSMakeSize(28.0f, 25.0f)];
		[toolbarButton setTitle:@"SWM"];
		[toolbarButton setAllowsMixedState:NO];
		[toolbarButton setBordered:YES];
		[toolbarButton setTransparent:NO];
		[toolbarButton setShowsBorderOnlyWhileMouseInside:NO];
		[toolbarButton setIgnoresMultiClick:NO];
		[toolbarButton setContinuous:NO];
		[toolbarButton setAutoresizesSubviews:YES];
		
//		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//		toolbarButtonShouldBeInserted = [defaults boolForKey:@"SWM.toolbarButtonShouldBeInserted"];
//		toolbarButtonIndex = [defaults integerForKey:@"SWM.toolbarButtonIndex"];
	}
	return self;
}

- (void)setMaxObjectsInWindowHistory:(NSUInteger)newValue {
	if (newValue < [windowHistory count]) {
		self.windowHistory = [NSMutableArray arrayWithArray:[windowHistory subarrayWithRange:NSMakeRange(0, maxObjectsInWindowHistory)]];
	}
	maxObjectsInWindowHistory = newValue;
}

- (void)safariWindowWillClose:(BrowserWindow*)closingWindow {
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
	[windowHistory insertObject:windowObject atIndex:0];
	// If limit exceeds, array will remove last object.
	if (maxObjectsInWindowHistory < [windowHistory count]) {
		[windowHistory removeLastObject];
	}
}

- (NSButton*)toolbarButton:(BrowserToolbar *)toolbar {
	return toolbarButton;
}
- (NSString*)toolbarButtonIdentifier:(BrowserToolbar *)toolbar {
	return toolbarButtonIdentifier;
}

- (void)safariToolbarWillAddItem:(NSNotification*)notification {
	NSLog(@"%@", [notification userInfo]);
	if ([[notification valueForKeyPath:@"userInfo.item.itemIdentifier"] isEqualToString:toolbarButtonIdentifier]) {
		//self.toolbarButtonShouldBeInserted = YES;
		//self.toolbarButtonIndex = [[notification valueForKeyPath:@"userInfo.newIndex"] intValue];
	}
}
- (void)safariToolbarDidRemoveItem:(NSNotification*)notification {
	NSLog(@"%@", [notification userInfo]);
	if ([[notification valueForKeyPath:@"userInfo.item.itemIdentifier"] isEqualToString:toolbarButtonIdentifier]) {
		//self.toolbarButtonShouldBeInserted = NO;
	}
}

@end
