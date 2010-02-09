//
//  UndoCloseTabExtension.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 09.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMUndoCloseTabExtension.h"
#import "JRSwizzle.h"
#import "Runtime.h"

@implementation SWMUndoCloseTabExtension

static BOOL g_UndoCloseTabExtension_Enabled = FALSE;

#pragma mark Extending
+ (BOOL)enableExtension:(NSError**)error {
	Class origClass = [self extendedClass];
	class_addMethodsFromClass(origClass, self);
	g_UndoCloseTabExtension_Enabled = [origClass jr_swizzleMethod:@selector(closeTab:) withMethod:@selector(SWMCloseTab:) error:error];
	
	return g_UndoCloseTabExtension_Enabled;
}
+ (void)disableExtension {
	g_UndoCloseTabExtension_Enabled = FALSE;
}
+ (Class)extendedClass {
	return NSClassFromString(@"BrowserWindowController");
}
+ (BOOL)isEnabled {
	return g_UndoCloseTabExtension_Enabled;
}

- (void)SWMCloseTab:(BrowserTabViewItem*)arg {
	if (g_UndoCloseTabExtension_Enabled) {		
		NSLog(@"SWMCloseTab: is called");
		// At runtime this method will belong to BrowserWindowController and have the closeTab: selector
		BrowserWebView* tab = [(BrowserTabViewItem*)arg webView];
		
		// Create undo action
		NSUndoManager *undoManager = [tab undoManagerForWebView:tab];		
		[undoManager beginUndoGrouping];
		[undoManager setActionName:NSLocalizedString(@"Close Tab", nil)];
		[undoManager registerUndoWithTarget:self selector:@selector(SWMNewTabWithURL:) object:[tab currentURL]];
		[undoManager endUndoGrouping];
	}
	
	[self SWMCloseTab:arg];
}
- (void)SWMNewTabWithURL:(NSURL*)url {
	NSAssert(g_UndoCloseTabExtension_Enabled, @"SWMNewTabWithURL: was called while extension was disabled");
	NSLog(@"SWMNewTabWithURL: is called");
	// At runtime this method will belong to BrowserWindowController
	BrowserWebView* tab = [(BrowserWindowController*)self createTab];
	[tab goToURL:url];
	
	// Find BrowserTabViewItem for current tab
	BrowserTabViewItem* currentTabItem = [[(BrowserWindowController*)self window] currentTabViewItem];
	
	// Create redo action
	NSUndoManager *undoManager = [tab undoManagerForWebView:tab];		
	[undoManager beginUndoGrouping];
	[undoManager setActionName:NSLocalizedString(@"Close Tab", nil)];
	[undoManager registerUndoWithTarget:self selector:@selector(closeTab:) object:currentTabItem]; // At runtime closeTab will equal to SWMCloseTab:
	[undoManager endUndoGrouping];
}

@end
