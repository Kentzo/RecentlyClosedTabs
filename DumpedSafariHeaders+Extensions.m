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

void class_addMethodsFromClass(Class dest, Class source) {
	// Get method list of source class
	unsigned int list_size;
	Method* methodList = class_copyMethodList(source, &list_size);
	
	// Add methods from the list to dest class
	for(; list_size > 0; --list_size) {
		Method meth = methodList[list_size - 1];
		SEL sel = method_getName(meth);
		const char* encod = method_getTypeEncoding(meth);
		IMP imp = class_getMethodImplementation(source, sel);
		class_addMethod(dest, sel, imp, encod);
	}
}

@implementation BrowserWindowControllerExtension
#pragma mark SWMExtending
+ (BOOL)loadExtension:(NSError**)error {
	Class origClass = NSClassFromString(@"BrowserWindowController");
	class_addMethodsFromClass(origClass, self);
	
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
	NSUndoManager *undoManager = [tab undoManagerForWebView:tab];		
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
	[[NSNotificationCenter defaultCenter] postNotificationName:SWMSafariTabWasOpenedNotification object:tab];
	
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

@implementation BrowserWindowExtension
#pragma mark SWMExtending
+ (BOOL)loadExtension:(NSError**)error {
	Class origClass = NSClassFromString(@"BrowserWindow");
	class_addMethodsFromClass(origClass, self);
	
	// Swizzle
	return [origClass jr_swizzleMethod:@selector(close) withMethod:@selector(SWMCloseWindow) error:error];
}

+ (void)unloadExtension {
	Class origClass = NSClassFromString(@"BrowserWindow");
	[origClass jr_swizzleMethod:@selector(close) withMethod:@selector(SWMCloseWindow) error:nil];
}

#pragma mark Extension Methods
- (void)SWMCloseWindow {
	NSLog(@"SWMCloseWindow is called");
	// At runtime this method will belong to BrowserWindow and have close selector
	BrowserWindowController* windowController = [(BrowserWindow*)self windowController];
	// Get tabs for removing window
	NSArray* tabs = [windowController orderedTabs];
	[[NSNotificationCenter defaultCenter] postNotificationName:SWMSafariWindowWillCloseNotification object:tabs];

	[self SWMCloseWindow];
}

@end

@implementation BrowserDocumentControllerExtension
#pragma mark SWMExtending
+ (BOOL)loadExtension:(NSError**)error {
	Class origClass = NSClassFromString(@"BrowserDocumentController");
	class_addMethodsFromClass(origClass, self);
	
	// Swizzle
	return [origClass jr_swizzleMethod:@selector(removeDocument:) withMethod:@selector(SWMRemoveDocument:) error:error];
}

+ (void)unloadExtension {
	Class origClass = NSClassFromString(@"BrowserDocumentController");
	[origClass jr_swizzleMethod:@selector(removeDocument:) withMethod:@selector(SWMRemoveDocument:) error:nil];
}

#pragma mark Extension Methods
- (void)SWMReOpenDocumnetWithTabs:(NSArray*)tabURLs {
	NSLog(@"SWMReOpenDocumnetWithTabs: is called with tabs:\n%@", tabURLs);
	// At runtime this method will belong to BrowserDocumentController
	BrowserDocument* document = [(BrowserDocumentController*)self openEmptyBrowserDocument];
	BrowserWindowController* windowController = [document browserWindowController];
	for (NSURL* url in tabURLs) {
		BrowserWebView* tab = [windowController createTab];
		[tab goToURL:url];
	}
}

@end
