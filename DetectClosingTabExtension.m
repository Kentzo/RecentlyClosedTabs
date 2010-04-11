//
//  RCTDetectClosingTabExtension.m
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 16.02.10.
//  Copyright 2010. All rights reserved.
//

#import "DetectClosingTabExtension.h"
#import "JRSwizzle.h"
#import "Runtime.h"


@implementation DetectClosingTabExtension

static BOOL g_DetectClosingTabExtension_Enabled = NO;
static id<DetectClosingTabExtensionDelegate> g_DetectClosingTabExtension_Delegate = nil;

+ (BOOL)enableExtensionWithDelegate:(id<NSObject, DetectClosingTabExtensionDelegate>)delegate error:(NSError**)error {
	static BOOL s_DetectClosingTabExtension_Initialized = NO;
	if (!s_DetectClosingTabExtension_Initialized) {
		Class origClass = [self extendedClass];
		class_addMethodsFromClass(origClass, self);
		g_DetectClosingTabExtension_Delegate = delegate;
		g_DetectClosingTabExtension_Enabled = [origClass jr_swizzleMethod:@selector(closeTab:)
														  withMethod:@selector(RCTCloseTab:)
															   error:error] &&
												[origClass jr_swizzleMethod:@selector(windowWillClose:)
																 withMethod:@selector(RCTWindowWillClose:)
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

- (void)RCTCloseTab:(BrowserTabViewItem*)arg1 {
	if (g_DetectClosingTabExtension_Enabled) {
		[g_DetectClosingTabExtension_Delegate browserDocument:[[arg1 webView] document] willCloseBrowserWebView:[arg1 webView]];
	}
	[self RCTCloseTab:arg1];
}
- (void)RCTWindowWillClose:(NSNotification*)arg1 {
	if (g_DetectClosingTabExtension_Enabled) {
		BrowserWindow* window = [arg1 object];
		NSArray* orderedTabs = [window orderedTabViewItems];
		for (BrowserTabViewItem* item in orderedTabs) {
			BrowserWebView* webView = [item webView];
			[g_DetectClosingTabExtension_Delegate browserDocument:[webView document] willCloseBrowserWebView:webView];
		}
	}
}

@end
