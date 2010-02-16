//
//  SWMDetectClosingTabExtension.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMDetectClosingTabExtension.h"
#import "JRSwizzle.h"
#import "Runtime.h"


@implementation SWMDetectClosingTabExtension

static BOOL g_DetectClosingTabExtension_Enabled = NO;
static id<SWMDetectClosingTabExtensionDelegate> g_DetectClosingTabExtension_Delegate = nil;

+ (BOOL)enableExtensionWithDelegate:(id<NSObject, SWMDetectClosingTabExtensionDelegate>)delegate error:(NSError**)error {
	static BOOL s_DetectClosingTabExtension_Initialized = NO;
	if (!s_DetectClosingTabExtension_Initialized) {
		Class origClass = [self extendedClass];
		class_addMethodsFromClass(origClass, self);
		g_DetectClosingTabExtension_Delegate = delegate;
		g_DetectClosingTabExtension_Enabled = [origClass jr_swizzleMethod:@selector(closeTab:)
														  withMethod:@selector(SWMCloseTab:)
															   error:error] &&
												[origClass jr_swizzleMethod:@selector(windowWillClose:)
																 withMethod:@selector(SWMWindowWillClose:)
																	  error:error];
		if (g_DetectClosingTabExtension_Enabled)
			s_DetectClosingTabExtension_Initialized = YES;
	}
	else {
		g_DetectClosingTabExtension_Enabled = YES;
	}

	
	return g_DetectClosingTabExtension_Enabled;
}
+ (void)disableExtension {
	g_DetectClosingTabExtension_Enabled = NO;
}
+ (BOOL)isEnabled {
	return g_DetectClosingTabExtension_Enabled;
}
+ (Class)extendedClass {
	return NSClassFromString(@"BrowserWindowController");
}

- (void)SWMCloseTab:(BrowserTabViewItem*)arg1 {
	if (g_DetectClosingTabExtension_Enabled) {
		NSLog(@"SWMCloseTab");
	}
	[self SWMCloseTab:arg1];
}
- (void)SWMWindowWillClose:(BrowserWindow*)arg1 {
	if (g_DetectClosingTabExtension_Enabled) {
		NSLog(@"SWMCloseTabOrWindow");
	}
}

@end
