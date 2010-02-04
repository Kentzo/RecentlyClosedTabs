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
@end

@interface BrowserWindowController
- (id)orderedTabs;
@end

@interface BrowserWebView
- (id)currentTitle;
- (id)currentURL;
@end