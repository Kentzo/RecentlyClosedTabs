/*
 *  DumpedSafariHeaders.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 02.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@class BrowserWindow, BrowserWindowController, BrowserWebView, BrowserTabViewItem, 
BrowserDocumentController, BrowserDocument, ToolbarController, BrowserToolbar, BrowserToolbarItem;

@interface BrowserWindow
- (BrowserWindowController*)windowController; // returns window controller of the window. Derived from NSWindow.
- (NSRect)frame; // returns frame of the window. Derived from NSWindow.
- (NSInteger)level; // returns layer level of the window. Derived from NSWindow.
- (BrowserTabViewItem*)currentTabViewItem; // returns selected BrowserTabViewItem object.
- (void)close; // this method will be called when BrowserWindow closes.
- (NSResponder *)nextResponder;
@end

@interface BrowserWindowController
- (NSArray*)orderedTabs; // returns ordered array of tabs.
- (void)closeTab:(BrowserTabViewItem*)arg1; // this method will be called when any tab are closed.
- (BrowserWebView*)createTab; // creates tab and returns it. 
- (BrowserWindow*)window; // returns window connected to the controller. Derived from NSWindowController.
- (BrowserDocument*)document; // returns BrowserDocument object which owns this window.
@end

@interface BrowserWebView
- (NSString*)currentTitle;
- (NSURL*)currentURL;
- (void)goToURL:(NSURL*)arg1;
- (NSUndoManager*)undoManagerForWebView:(BrowserWebView*)arg1;
@end

@interface BrowserTabViewItem
- (BrowserWebView*)webView;
@end

@interface BrowserDocument
- (BrowserWindowController*)browserWindowController;
- (NSUndoManager*)undoManager;
@end

@interface BrowserDocumentController
- (BrowserDocument*)openEmptyBrowserDocument;
- (void)SWMReOpenDocumnetWithTabs:(NSArray*)tabURLs;
@end

@interface ToolbarController
- (BrowserToolbarItem*)toolbar:(BrowserToolbar*)arg1 itemForItemIdentifier:(NSString*)arg2 willBeInsertedIntoToolbar:(BOOL)arg3;
- (NSArray*)toolbarAllowedItemIdentifiers:(BrowserToolbar*)arg1;
- (NSArray*)toolbarDefaultItemIdentifiers:(BrowserToolbar*)arg1;
@end

@interface BrowserToolbarItem
- (id)initWithItemIdentifier:(id)arg1 target:(id)arg2 button:(id)arg3;
+ (id)alloc;
@end
