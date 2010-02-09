//
//  SWMPluginController.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWMCustomToolbarButtonExtension.h"


@class BrowserWindow;

@interface SWMPluginController : NSObject <SWMCustomToolbarButtonExtensionDelegate> {
	NSMutableArray* windowHistory;
	NSUInteger maxObjectsInWindowHistory;
	// Button and it's identifier for safari toolbar
	NSString* toolbarButtonIdentifier;
	NSButton* toolbarButton;
}
@property (retain) NSMutableArray* windowHistory;
@property NSUInteger maxObjectsInWindowHistory;

+ (SWMPluginController*)sharedInstance;

- (void)safariWindowWillClose:(BrowserWindow*)closingWindow;
- (void)safariToolbarWillAddItem:(NSNotification*)notification;
- (void)safariToolbarDidRemoveItem:(NSNotification*)notification;

@end
