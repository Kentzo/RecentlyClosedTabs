//
//  SWMCustomToolbarButtonExtension.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 09.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DumpedSafariHeaders.h"
#import "UnallocableObject.h"
#import "Extending.h"


@protocol CustomToolbarButtonExtensionDelegate
@required
- (NSButton*)toolbarButton:(BrowserToolbar*)toolbar;
- (NSString*)toolbarButtonIdentifier:(BrowserToolbar*)toolbar;
- (NSString*)toolbarButtonToolTip:(BrowserToolbar*)toolbar;
- (SEL)toolbarButtonAction:(BrowserToolbar*)toolbar;
@end

@interface CustomToolbarButtonExtension : UnallocableObject <DelegateExtending>
- (BrowserToolbarItem*)SWMToolbar:(BrowserToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted;
- (NSArray*)SWMToolbarAllowedItemIdentifiers:(BrowserToolbar*)toolbar;
@end