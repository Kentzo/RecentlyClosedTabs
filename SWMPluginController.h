//
//  SWMPluginController.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class BrowserWindow;

@interface SWMPluginController : NSObject {
	NSMutableArray* windowHistory;
	NSUInteger maxObjectsInWindowHistory;
	// Button and it's identifier for safari toolbar
	NSString* toolbarButtonIdentifier;
	NSButton* toolbarButton;
	BOOL toolbarButtonShouldBeInserted;
	NSUInteger toolbarButtonIndex;
}
@property (retain) NSMutableArray* windowHistory;
@property NSUInteger maxObjectsInWindowHistory;

@property (readonly) NSString* toolbarButtonIdentifier;
@property (readonly) NSButton* toolbarButton;
@property (readonly) BOOL toolbarButtonShouldBeInserted;
@property (readonly) NSUInteger toolbarButtonIndex;

+ (SWMPluginController*)sharedInstance;

- (void)safariWindowWillClose:(BrowserWindow*)closingWindow;
- (void)safariToolbarWillAddItem:(NSNotification*)notification;
- (void)safariToolbarDidRemoveItem:(NSNotification*)notification;

@end
