/*
 *  DumpedSafariHeaders+ReplacingMethods.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 05.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import "DumpedSafariHeaders.h"
#import "Extending.h"


@interface BrowserWindowControllerExtension : NSObject <Extending>
- (void)SWMCloseTab:(BrowserTabViewItem*)arg;
- (void)SWMNewTabWithURL:(NSURL*)url;
@end

@interface BrowserWindowExtension : NSObject <Extending>
- (void)SWMCloseWindow;
@end

@interface BrowserDocumentControllerExtension : NSObject <Extending>
- (void)SWMReOpenDocumnetWithTabs:(NSArray*)tabURLs;
@end

@interface CustomToolBarButtonExtension : NSObject <Extending>
- (BrowserToolbarItem*)SWMToolbar:(BrowserToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted;
- (NSArray*)SWMToolbarAllowedItemIdentifiers:(BrowserToolbar*)toolbar;
@end