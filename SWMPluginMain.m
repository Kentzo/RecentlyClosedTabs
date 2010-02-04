//
//  SWMPlugin.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMPluginMain.h"
#import "DumpedSafariHeaders.h"
#import "NSNull+ObjectOrNull.h"
#import "JRSwizzle.h"

#pragma mark Singleton Instance
static SWMPluginMain* g_sharedSWMPluginInstance = nil;

@implementation SWMPluginMain

+ (void)load {
	NSLog(@"SWMPlugin will load");
	// Add observer for NSWindowWillCloseNotification
	[[NSNotificationCenter defaultCenter] addObserver:[self sharedPlugin] selector:@selector(safariWindowWillClose:) name:@"NSWindowWillCloseNotification" object:nil];
	NSLog(@"SWMPlugin did load");
}
#pragma mark Singleton Pattern
+ (SWMPluginMain*)sharedPlugin {
	@synchronized(self) {
		if (g_sharedSWMPluginInstance == nil) {
			g_sharedSWMPluginInstance = [SWMPluginMain new];
		}
	}
	return g_sharedSWMPluginInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (g_sharedSWMPluginInstance == nil) {
			g_sharedSWMPluginInstance = [super allocWithZone:zone];
			return g_sharedSWMPluginInstance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void)dealloc {
	NSLog(@"SWMPlugin will dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:[[self class] sharedInstance] name:@"NSWindowWillCloseNotification" object:nil];
	NSLog(@"SWMPlugin did dealloc");
	[super dealloc];
}

- (void)safariWindowWillClose:(NSNotification *)notification {
	if ([[notification object] class] == NSClassFromString(@"BrowserWindow")) {
		BrowserWindow* closingWindow = [notification object];
		NSArray* closingWindowTabs = [(BrowserWindowController*)[closingWindow windowController] orderedTabs];
		NSMutableArray* windowTabsHistory = [NSMutableArray arrayWithCapacity:[closingWindowTabs count]];
		for (BrowserWebView* tab in closingWindowTabs) {
			id title = [tab currentTitle];
			id url = [tab currentURL];
			if (title != nil && url != nil)
				[windowTabsHistory addObject:[NSDictionary dictionaryWithObject:url forKey:title]];
		}
		NSLog(@"%@", [windowTabsHistory description]);
	}
}

@end
