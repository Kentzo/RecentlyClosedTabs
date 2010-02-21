/*
 *  DumpedSafariHeaders.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 02.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@class BrowserWindow, BrowserWindowController, BrowserWebView, BrowserTabViewItem, 
BrowserDocumentController, BrowserDocument, ToolbarController, BrowserToolbar, BrowserToolbarItem, TabButton, TabBarView;

#pragma mark windowPolicy
typedef enum _windowPolicy {
	CurrentTabWindowPolicy = 0, // Either opens URL in the current tab or creates new window, if no windows are existed
	CurrentTab2WindowPolicy, // Same as CurrentTabWindowPolicy
	NewWindowWindowPolicy, // Creates new window and opens URL
	NewWindowBackgroundWindowPolicy, // Creates new window at background and opens URL
	NewTabWindowPolicy, // Creates new tab at the front window or creates new window, if no windows are existed
	NewTabBackgroundWindowPolicy, // Creates new tab at the front window, but don't switch to it. Creates new window if no windows are existed
	LocateOrCreateTabWindowPolicy, // If some window has webview with current url, switch to it and update. Otherwise create new tab or new window
	LocateOrCreate2TabWindowPolicy // Same as LocateOrCreateTabWindowPolicy
} windowPolicy;

#pragma mark -
#pragma mark Windows
@interface BrowserWindow : NSWindow
- (BrowserTabViewItem*)currentTabViewItem; // returns selected BrowserTabViewItem object.
- (void)close; // this method will be called when BrowserWindow closes.
- (BrowserToolbar*)toolbar;
- (id)orderedTabViewItems;
@end

@interface BrowserWindowController : NSWindowController
- (NSArray*)orderedTabs; // returns ordered array of tabs.
- (void)closeTab:(BrowserTabViewItem*)arg1; // this method will be called when any tab are closed.
- (void)closeTabOrWindow:(id)arg1;
- (void)_closeWindowIfNoTabs;
- (BrowserWebView*)createTab; // creates tab and returns it. 
- (BrowserWindow*)window; // returns window connected to the controller. Derived from NSWindowController.
- (BrowserDocument*)document; // returns BrowserDocument object which owns this window.
@end

#pragma mark -
#pragma mark Web Views
@interface BrowserWebView
- (NSString*)currentTitle;
- (NSURL*)currentURL;
- (void)goToURL:(NSURL*)arg1;
- (NSUndoManager*)undoManagerForWebView:(BrowserWebView*)arg1;
- (BrowserDocument*)document;
- (BOOL)isLoading;
//- (void)goToAddressInNewWindow:(id)arg1;
//- (void)openFrameInNewWindow:(id)arg1;
//- (void)openImageInNewWindow:(id)arg1;
//- (void)openLinkInNewWindow:(id)arg1;
//- (void)openURLInNewWindow:(id)arg1;

@end

#pragma mark -
#pragma mark Documents
@interface BrowserDocument : NSDocument
- (BrowserWindowController*)browserWindowController;
- (NSUndoManager*)undoManager;
- (void)goToURL:(id)arg1;
@end

@interface BrowserDocumentController : NSDocumentController
- (BrowserDocument*)openEmptyBrowserDocument;
- (void)SWMReOpenDocumnetWithTabs:(NSArray*)tabURLs;
- (id)goToURL:(id)arg1 windowPolicy:(int)arg2;
@end

#pragma mark -
#pragma mark Toolbars
@interface ToolbarController
- (BrowserToolbarItem*)toolbar:(BrowserToolbar*)arg1 itemForItemIdentifier:(NSString*)arg2 willBeInsertedIntoToolbar:(BOOL)arg3;
- (NSArray*)toolbarAllowedItemIdentifiers:(BrowserToolbar*)arg1;
@end

@interface BrowserToolbar
- (void)_userInsertItemWithItemIdentifier:(NSString*)arg1 atIndex:(long long)arg2;
- (void)removeItemWithIdentifier:(id)arg1;
- (id)valueForKeyPath:(NSString*)path;
@end

@interface BrowserToolbarItem
- (id)initWithItemIdentifier:(id)arg1 target:(id)arg2 button:(id)arg3;
+ (id)alloc;
- (void)setToolTip:(NSString *)toolTip;
- (void)setAction:(SEL)action;
@end

#pragma mark -
#pragma mark Tab Bars
@interface TabButton : NSButton
- (void)mouseDown:(NSEvent *)theEvent;
- (BrowserTabViewItem*)tabViewItem;
- (void)closeTab:(id)arg1;
- (TabBarView*)superview;
@end

@interface TabBarView : NSView
- (unsigned long long)numberOfTabs;
@end

@interface BrowserTabViewItem 
- (BrowserWebView*)webView;
- (NSString*)title;
- (NSString*)URLString;
@end

