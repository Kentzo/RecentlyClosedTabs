//
//  SWMCustomToolbarButtonExtension.h
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 09.02.10.
//  Copyright 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreFoundation/CoreFoundation.h>
#import "DumpedSafariHeaders.h"
#import "Extending.h"


@protocol CustomToolbarButtonExtensionDelegate
@required
- (NSButton*)toolbarButton:(BrowserToolbar*)toolbar;
- (NSString*)toolbarButtonIdentifier:(BrowserToolbar*)toolbar;
- (NSString*)toolbarButtonToolTip:(BrowserToolbar*)toolbar;
- (SEL)toolbarButtonAction:(BrowserToolbar*)toolbar;
@end

@interface CustomToolbarButtonExtension : NSObject <DelegateExtending>
- (BrowserToolbarItem*)SWMToolbar:(BrowserToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted;
- (NSArray*)SWMToolbarAllowedItemIdentifiers:(BrowserToolbar*)toolbar;
+ (void)storeToolbarItemIdentifiers:(NSNotification*)notification;
@end