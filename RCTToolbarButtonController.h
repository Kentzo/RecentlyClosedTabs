//
//  SWMToolbarButtonController.h
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 15.02.10.
//  Copyright 2010. All rights reserved.
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
