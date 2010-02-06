/*
 *  DumpedSafariHeaders.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 02.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@interface BrowserWindow
- (id)windowController;
- (NSRect)frame;
- (NSInteger)level;
- (id)currentTabViewItem;
@end

@interface BrowserWindowController
- (id)orderedTabs;
- (id)orderedTabViewItems;
- (void)closeTab:(id)arg1;
- (id)createTab;
@end

@interface BrowserWebView
- (id)currentTitle;
- (id)currentURL;
- (id)document;
- (void)goToURL:(id)arg1;
- (id)undoManagerForWebView:(id)arg1;
@end

@interface BrowserTabViewItem
- (id)webView;
@end