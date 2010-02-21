//
//  SWMDetectClosingTabExtension.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DumpedSafariHeaders.h"
#import "UnallocableObject.h"
#import "Extending.h"


@protocol DetectClosingTabExtensionDelegate
@required
- (void)browserDocument:(BrowserDocument*)document willCloseBrowserWebView:(BrowserWebView*)browserWebView;
@end

@interface DetectClosingTabExtension : UnallocableObject <DelegateExtending>
- (void)SWMCloseTab:(BrowserTabViewItem*)arg1;
- (void)SWMWindowWillClose:(NSNotification*)arg1;
@end
