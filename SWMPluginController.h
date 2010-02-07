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
}
@property (retain) NSMutableArray* windowHistory;
@property NSUInteger maxObjectsInWindowHistory;

+ (SWMPluginController*)sharedInstance;

- (void)safariWindowWillClose:(BrowserWindow*)closingWindow;

@end
