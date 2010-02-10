///*
// *  DumpedSafariHeaders+ReplacingMethods.m
// *  SafariWindowManager
// *
// *  Created by Илья Кулаков on 05.02.10.
// *  Copyright 2010 __MyCompanyName__. All rights reserved.
// *
// */
//
//#import "DumpedSafariHeaders+Extensions.h"
//#import "JRSwizzle.h"
//#import <objc/objc-class.h>
//#import "SWMPluginController.h"
//
//
//void class_addMethodsFromClass(Class dest, Class source) {
//	// Get method list of source class
//	unsigned int list_size;
//	Method* methodList = class_copyMethodList(source, &list_size);
//	
//	// Add methods from the list to dest class
//	for(; list_size > 0; --list_size) {
//		Method meth = methodList[list_size - 1];
//		SEL sel = method_getName(meth);
//		const char* encod = method_getTypeEncoding(meth);
//		IMP imp = class_getMethodImplementation(source, sel);
//		class_addMethod(dest, sel, imp, encod);
//	}
//}
//
//@implementation BrowserWindowControllerExtension
//+ (BOOL)disableExtension:(NSError**)error {
//	Class origClass = NSClassFromString(@"BrowserWindowController");
//	class_addMethodsFromClass(origClass, self);
//	
//	// Swizzle
//	return [origClass jr_swizzleMethod:@selector(closeTab:) withMethod:@selector(SWMCloseTab:) error:error];
//}
//+ (void)disableExtension {
//	Class origClass = NSClassFromString(@"BrowserWindowController");
//	[origClass jr_swizzleMethod:@selector(closeTab:) withMethod:@selector(SWMCloseTab:) error:nil];
//}
//
//- (void)SWMCloseTab:(BrowserTabViewItem*)arg {
//	NSLog(@"SWMCloseTab: is called");
//	// At runtime this method will belong to BrowserWindowController and have the CloseTab: selector
//	BrowserWebView* tab = [(BrowserTabViewItem*)arg webView];
//	
//	// Create undo action
//	NSUndoManager *undoManager = [tab undoManagerForWebView:tab];		
//	[undoManager beginUndoGrouping];
//	[undoManager setActionName:@"Close tab"];
//	[undoManager registerUndoWithTarget:self selector:@selector(SWMNewTabWithURL:) object:[tab currentURL]];
//	[undoManager endUndoGrouping];
//	
//	[self SWMCloseTab:arg];
//}
//- (void)SWMNewTabWithURL:(NSURL*)url {
//	NSLog(@"SWMNewTabWithURL: is called");
//	// At runtime this method will belong to BrowserWindowController
//	BrowserWebView* tab = [(BrowserWindowController*)self createTab];
//	[tab goToURL:url];
//	
//	// Find BrowserTabViewItem for current tab
//	BrowserTabViewItem* currentTabItem = [[(BrowserWindowController*)self window] currentTabViewItem];
//
//	// Create redo action
//	NSUndoManager *undoManager = [tab undoManagerForWebView:tab];		
//	[undoManager beginUndoGrouping];
//	[undoManager setActionName:@"Close tab"];
//	[undoManager registerUndoWithTarget:self selector:@selector(closeTab:) object:currentTabItem]; // At runtime closeTab will equal to SWMCloseTab:
//	[undoManager endUndoGrouping];
//}
//
//@end
//
//@implementation BrowserWindowExtension
//+ (BOOL)disableExtension:(NSError**)error {
//	Class origClass = NSClassFromString(@"BrowserWindow");
//	class_addMethodsFromClass(origClass, self);
//	
//	// Swizzle
//	return [origClass jr_swizzleMethod:@selector(close) withMethod:@selector(SWMCloseWindow) error:error];
//}
//+ (void)disableExtension {
//	Class origClass = NSClassFromString(@"BrowserWindow");
//	[origClass jr_swizzleMethod:@selector(close) withMethod:@selector(SWMCloseWindow) error:nil];
//}
//
//- (void)SWMCloseWindow {
//	NSLog(@"SWMCloseWindow is called");
//	// At runtime this method will belong to BrowserWindow and have close selector
//	BrowserWindowController* windowController = [(BrowserWindow*)self windowController];
//	// Get tabs for removing window
//	NSArray* tabs = [windowController orderedTabs];
//	
//	SWMPluginController* pluginController = [SWMPluginController sharedInstance];
//	@synchronized(pluginController) {
//		[pluginController safariWindowWillClose:(BrowserWindow*)self];
//	}
//
//	[self SWMCloseWindow];
//}
//
//@end
//
//@implementation BrowserDocumentControllerExtension
//+ (BOOL)disableExtension:(NSError**)error {
//	Class origClass = NSClassFromString(@"BrowserDocumentController");
//	class_addMethodsFromClass(origClass, self);
//	
//	return YES;
//}
//+ (void)disableExtension {
//	Class origClass = NSClassFromString(@"BrowserDocumentController");
//}
//
//- (void)SWMReOpenDocumnetWithTabs:(NSArray*)tabURLs {
//	NSLog(@"SWMReOpenDocumnetWithTabs: is called with tabs:\n%@", tabURLs);
//	// At runtime this method will belong to BrowserDocumentController
//	BrowserDocument* document = [(BrowserDocumentController*)self openEmptyBrowserDocument];
//	BrowserWindowController* windowController = [document browserWindowController];
//	for (NSURL* url in tabURLs) {
//		BrowserWebView* tab = [windowController createTab];
//		[tab goToURL:url];
//	}
//}
//
//@end
//
//@implementation CustomToolBarButtonExtension
//+ (BOOL)disableExtension:(NSError**)error {
//	Class origClass = NSClassFromString(@"ToolbarController");
//	class_addMethodsFromClass(origClass, self);
//	
//	BOOL result = [origClass jr_swizzleMethod:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:) 
//								   withMethod:@selector(SWMToolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:) error:error] &&
//				[origClass jr_swizzleMethod:@selector(toolbarAllowedItemIdentifiers:) 
//								 withMethod:@selector(SWMToolbarAllowedItemIdentifiers:) error:error];
//	
//	[[NSNotificationCenter defaultCenter] addObserver:[SWMPluginController sharedInstance]
//											 selector:@selector(safariToolbarWillAddItem:)
//												 name:NSToolbarWillAddItemNotification
//											   object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:[SWMPluginController sharedInstance]
//											 selector:@selector(safariToolbarDidRemoveItem:) 
//												 name:NSToolbarDidRemoveItemNotification 
//											   object:nil];
//	
//	//if ([[SWMPluginController sharedInstance] toolbarButtonShouldBeInserted]) {
//		NSDocumentController* documentContr = [NSDocumentController sharedDocumentController];
//		NSWindowController* windowContr = [[[documentContr documents] objectAtIndex:0] browserWindowController];
//		NSWindow* window = [windowContr window];
//		NSToolbar* toolbar = [window toolbar];
//	
//		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//		NSDictionary* toolbarConf = [defaults dictionaryForKey:@"NSToolbar Configuration BrowserWindowToolbarIdentifier"];
//		NSArray* itemIdent = [toolbarConf objectForKey:@"TB Item Identifiers"];
//	
//		NSLog(@"toolbar items:\n%@", [toolbar valueForKeyPath:@"items.itemIdentifier"]);
//		NSLog(@"toolbar visible items:\n%@", [toolbar valueForKeyPath:@"visibleItems.itemIdentifier"]);
////		[toolbar _userInsertItemWithItemIdentifier:[[SWMPluginController sharedInstance] toolbarButtonIdentifier]
////										   atIndex:[[SWMPluginController sharedInstance] toolbarButtonIndex]];
////		[toolbar insertItemWithItemIdentifier:[[SWMPluginController sharedInstance] toolbarButtonIdentifier] 
////									  atIndex:[[SWMPluginController sharedInstance] toolbarButtonIndex]];
////	}
//	
//	return result;
//}
//+ (void)disableExtension {
//	Class origClass = NSClassFromString(@"ToolbarController");
//	[origClass jr_swizzleMethod:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:) 
//					 withMethod:@selector(SWMToolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:) error:nil];
//	[origClass jr_swizzleMethod:@selector(toolbarAllowedItemIdentifiers:) 
//					 withMethod:@selector(SWMToolbarAllowedItemIdentifiers:) error:nil];
//	
//	[[NSNotificationCenter defaultCenter] removeObserver:[SWMPluginController sharedInstance] name:NSToolbarWillAddItemNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:[SWMPluginController sharedInstance] name:NSToolbarDidRemoveItemNotification object:nil];
//}
//
//- (BrowserToolbarItem*)SWMToolbar:(BrowserToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted {
//	static BrowserToolbarItem* SWMToolBarItem = nil;
//	if (SWMToolBarItem == nil) {
//		NSButton* SWMButton = [[SWMPluginController sharedInstance] toolbarButton];
//		SWMToolBarItem = [[NSClassFromString(@"BrowserToolbarItem") alloc] 
//						  initWithItemIdentifier:[[SWMPluginController sharedInstance] toolbarButtonIdentifier]
//						  target:self
//						  button:SWMButton];
//	}
//	
//	if ([identifier isEqualToString:[[SWMPluginController sharedInstance] toolbarButtonIdentifier]]) {
//		return SWMToolBarItem;
//	}
//	else {
//		[self SWMToolbar:toolbar itemForItemIdentifier:identifier willBeInsertedIntoToolbar:willBeInserted];
//	}
//}
//- (NSArray*)SWMToolbarAllowedItemIdentifiers:(BrowserToolbar*)toolbar {
//	return [[self SWMToolbarAllowedItemIdentifiers:toolbar] arrayByAddingObject:[[SWMPluginController sharedInstance] toolbarButtonIdentifier]];
//}
//
//@end
//
