/*
 *  DumpedSafariHeaders+ReplacingMethods.m
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 05.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import "DumpedSafariHeaders+Extensions.h"
#import "JRSwizzle.h"
#import <objc/objc-class.h>
#import "SWMNotifications.h"


@implementation BrowserWindowControllerExtension
#pragma mark SWMExtending
+ (BOOL)loadExtension:(NSError**)error {
	// Get method list of BrowserWindowControllerExtension
	unsigned int list_size;
	Method* methodList = class_copyMethodList(self, &list_size);
	
	// Add methods from the list to BrowserWindowController
	Class origClass = NSClassFromString(@"BrowserWindowController");
	for(; list_size > 0; --list_size) {
		Method meth = methodList[list_size - 1];
		SEL sel = method_getName(meth);
		const char* encod = method_getTypeEncoding(meth);
		IMP imp = class_getMethodImplementation(self, sel);
		class_addMethod(origClass, sel, imp, encod);
	}
	
	// Swizzle
	return [origClass jr_swizzleMethod:@selector(closeTab:) withMethod:@selector(SWMCloseTab:) error:error];
}
+ (void)unloadExtension {
	Class origClass = NSClassFromString(@"BrowserWindowController");
	[origClass jr_swizzleMethod:@selector(closeTab:) withMethod:@selector(SWMCloseTab:) error:nil];
}

#pragma mark Extension Methods
- (void)SWMCloseTab:(id)arg {
	NSLog(@"SWMCloseTab: is called");
	// At runtime this method will belong to BrowserWindowController and have the CloseTab: selector
	BrowserWebView* tab = [(BrowserTabViewItem*)arg webView];
	[[NSNotificationCenter defaultCenter] postNotificationName:SWMSafariTabWillCloseNotification object:tab];
	
	// Create undo action
	NSUndoManager *undoManager = [[tab document] undoManager];		
	[undoManager beginUndoGrouping];
	[undoManager setActionName:@"Close tab"];
	[undoManager registerUndoWithTarget:self selector:@selector(SWMNewTabWithURL:) object:[tab currentURL]];
	[undoManager endUndoGrouping];
	
	[self SWMCloseTab:arg];
}
- (void)SWMNewTabWithURL:(NSURL*)url {
	NSLog(@"SWMNewTabWithURL: is called");
	// At runtime this method will belong to BrowserWindowController
	BrowserWebView* tab = [(BrowserWindowController*)self createTab];
	[tab goToURL:url];
	[[NSNotificationCenter defaultCenter] postNotificationName:SWMSafariTabIsOpenedNotification object:tab];
	
	// Find BrowserTabViewItem for current tab
	BrowserTabViewItem* foundTabItem = nil;
	NSArray* tabsItem = [(BrowserWindowController*)self orderedTabViewItems];
	for (BrowserTabViewItem* tabItem in tabsItem) {
		if ([tabItem webView] == tab) {
			foundTabItem = tabItem;
			break;
		}
	}

	// Create redo action
	NSUndoManager *undoManager = [[tab document] undoManager];		
	[undoManager beginUndoGrouping];
	[undoManager setActionName:@"Close tab"];
	[undoManager registerUndoWithTarget:self selector:@selector(closeTab:) object:foundTabItem]; // At runtime closeTab will equal to SWMCloseTab:
	[undoManager endUndoGrouping];
}
@end
