//
//  RCTDetectClosingTabExtension.h
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 16.02.10.
//  Copyright 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DumpedSafariHeaders.h"
#import "Extending.h"


@protocol DetectClosingTabExtensionDelegate
@required
- (void)browserDocument:(BrowserDocument*)document willCloseBrowserWebView:(BrowserWebView*)browserWebView;
@end

@interface DetectClosingTabExtension : NSObject <DelegateExtending>
- (void)RCTCloseTab:(BrowserTabViewItem*)arg1;
- (void)RCTWindowWillClose:(NSNotification*)arg1;
@end
