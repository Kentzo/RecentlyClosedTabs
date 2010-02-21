//
//  SWMToolbarButtonController.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 15.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomToolbarButtonExtension.h"
#import "DetectClosingTabExtension.h"


@class RCTRecentlyClosedTabsWindowContoller;

@interface RCTToolbarButtonController : NSObject <CustomToolbarButtonExtensionDelegate, DetectClosingTabExtensionDelegate> {
	NSButton* toolbarButton;
	RCTRecentlyClosedTabsWindowContoller* recentClosedTabsWindowController;
}

- (void)toolbarButtonClicked;

@end
