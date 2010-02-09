//
//  UndoCloseTabExtension.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 09.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMUndoCloseTabExtension.h"



@implementation UndoCloseTabExtension

static g_UndoCloseTabExtensionEnabled = FALSE;

#pragma mark Extending
+ (BOOL)enableExtension:(NSError**)error {
	class_addMethodsFromClass([self extendedClass], self);
	g_extensionEnabled = [origClass jr_swizzleMethod:@selector(closeTab:) withMethod:@selector(SWMCloseTab:) error:error];
	
	return g_extensionEnabled;
}
+ (void)disableExtension {
	g_extensionEnabled = FALSE;
}
+ (Class)extendedClass {
	return NSClassFromString(@"BrowserWindowController");
}
+ (BOOL)isEnabled {
	return g_extensionEnabled;
}

- (void)SWMCloseTab:(BrowserTabViewItem*)arg {
	if (g_UndoCloseTabExtensionEnabled) {		
		NSLog(@"SWMCloseTab: is called");
		// At runtime this method will belong to BrowserWindowController and have the closeTab: selector
		BrowserWebView* tab = [(BrowserTabViewItem*)arg webView];
		
		// Create undo action
		NSUndoManager *undoManager = [tab undoManagerForWebView:tab];		
		[undoManager beginUndoGrouping];
		[undoManager setActionName:@"Close tab"];
		[undoManager registerUndoWithTarget:self selector:@selector(SWMNewTabWithURL:) object:[tab currentURL]];
		[undoManager endUndoGrouping];
	}
	
	[self SWMCloseTab:arg];
}
- (void)SWMNewTabWithURL:(NSURL*)url {
	NSAssert(g_UndoCloseTabExtensionEnabled, @"SWMNewTabWithURL: was called while extension was disabled");
	NSLog(@"SWMNewTabWithURL: is called");
	// At runtime this method will belong to BrowserWindowController
	BrowserWebView* tab = [(BrowserWindowController*)self createTab];
	[tab goToURL:url];
	
	// Find BrowserTabViewItem for current tab
	BrowserTabViewItem* currentTabItem = [[(BrowserWindowController*)self window] currentTabViewItem];
	
	// Create redo action
	NSUndoManager *undoManager = [tab undoManagerForWebView:tab];		
	[undoManager beginUndoGrouping];
	[undoManager setActionName:@"Close tab"];
	[undoManager registerUndoWithTarget:self selector:@selector(closeTab:) object:currentTabItem]; // At runtime closeTab will equal to SWMCloseTab:
	[undoManager endUndoGrouping];
}

@end
