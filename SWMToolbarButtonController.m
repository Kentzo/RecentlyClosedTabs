//
//  SWMToolbarButtonController.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 15.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMToolbarButtonController.h"
#import "SWMDetectClosingTabExtension.h"

@implementation SWMToolbarButtonController

- init {
	if (self = [super init]) {
		toolbarButton = [NSButton new];
		[toolbarButton setBezelStyle:NSTexturedRoundedBezelStyle];
		[toolbarButton setFrameSize:NSMakeSize(28.0f, 25.0f)];
		[toolbarButton setTitle:@"1"];
		[toolbarButton setAllowsMixedState:NO];
		[toolbarButton setBordered:YES];
		[toolbarButton setTransparent:NO];
		[toolbarButton setShowsBorderOnlyWhileMouseInside:NO];
		[toolbarButton setIgnoresMultiClick:NO];
		[toolbarButton setContinuous:NO];
		[toolbarButton setAutoresizesSubviews:YES];
	}
	return self;
}

- (NSButton*)toolbarButton:(BrowserToolbar*)toolbar {
	return toolbarButton;
}
- (NSString*)toolbarButtonIdentifier:(BrowserToolbar*)toolbar {
	return @"ClosedTabHistory";
}
- (NSString*)toolbarButtonToolTip:(BrowserToolbar*)toolbar {
	return @"Display recent closed tabs";
}
- (SEL)toolbarButtonAction:(BrowserToolbar*)toolbar {
	return @selector(toolbarButtonClicked);
}

- (void)toolbarButtonClicked {
	if ([SWMDetectClosingTabExtension isEnabled]) {
		[SWMDetectClosingTabExtension disableExtension];
	}
	else {
		[SWMDetectClosingTabExtension enableExtensionWithDelegate:nil error:nil];
	}

}
@end
