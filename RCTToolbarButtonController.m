//
//  SWMToolbarButtonController.m
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 15.02.10.
//  Copyright 2010. All rights reserved.
//

#import "RCTToolbarButtonController.h"
#import "DetectClosingTabExtension.h"
#import "RCTRecentlyClosedTabsWindowContoller.h"
#import "RCTClosedTab.h"


@implementation RCTToolbarButtonController

- init {
	if (self = [super init]) {
		NSBundle* pluginBundle = [NSBundle bundleForClass:[self class]];
		NSImage* toolbarButtonIcon = [[NSImage alloc] initWithContentsOfFile:[pluginBundle pathForResource:@"ToolbarButtonIcon" ofType:@"png"]];
		
		toolbarButton = [NSButton new];
		[toolbarButton setBezelStyle:NSTexturedRoundedBezelStyle];
		[toolbarButton setFrameSize:NSMakeSize(28.0f, 25.0f)];
		[toolbarButton setTitle:@"Recently closed tabs"];
		[toolbarButton setToolTip:@"Display recently closed tabs"];
		[toolbarButton setImage:toolbarButtonIcon];
		[toolbarButton setAllowsMixedState:NO];
		[toolbarButton setBordered:YES];
		[toolbarButton setTransparent:NO];
		[toolbarButton setShowsBorderOnlyWhileMouseInside:NO];
		[toolbarButton setIgnoresMultiClick:NO];
		[toolbarButton setContinuous:NO];
		[toolbarButton setAutoresizesSubviews:YES];
		
		recentClosedTabsWindowController = [[RCTRecentlyClosedTabsWindowContoller alloc] init];
		
		[toolbarButtonIcon release];
	}
	return self;
}
- (void)dealloc {
	[toolbarButton release];
	[recentClosedTabsWindowController release];
	[super dealloc];
}

- (NSButton*)toolbarButton:(BrowserToolbar*)toolbar {
	return toolbarButton;
}
- (NSString*)toolbarButtonIdentifier:(BrowserToolbar*)toolbar {
	return @"ClosedTabHistory";
}
- (NSString*)toolbarButtonToolTip:(BrowserToolbar*)toolbar {
	return @"Display recent closed tabs";
}
- (SEL)toolbarButtonAction:(BrowserToolbar*)toolbar {
	return @selector(toolbarButtonClicked);
}

- (void)toolbarButtonClicked {
	[recentClosedTabsWindowController.window makeKeyAndOrderFront:nil];
}

- (void)browserDocument:(BrowserDocument*)document willCloseBrowserWebView:(BrowserWebView*)browserWebView {
//	if (![browserWebView isLoading]) {
	static NSURL* bookmarks, *topsites, *emptyurl;
	if (bookmarks == nil) {
		bookmarks = [[NSURL alloc] initWithString:@"bookmarks://"];
	}
	if (topsites == nil) {
		topsites = [[NSURL alloc] initWithString:@"topsites://"];
	}
	if (emptyurl == nil) {
		emptyurl = [[NSURL alloc] initWithString:@""];
	}
		NSString* title = [browserWebView currentTitle];
		NSURL* url = [browserWebView currentURL];
		NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
		if (url != nil && ![url isEqual:emptyurl] && ![url isEqual:bookmarks] && ![url isEqual:topsites]) {
			RCTClosedTab* tab = [[RCTClosedTab alloc] initWithTitle:title url:url date:date favicon:nil];
			[recentClosedTabsWindowController addClosedTab:tab];
			[tab release];
		}
    
//	}
}

@end
