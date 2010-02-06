/*
 *  DumpedSafariHeaders+ReplacingMethods.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 05.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import "DumpedSafariHeaders.h"
#import "SWMExtending.h"

@interface BrowserWindowControllerExtension : NSObject <SWMExtending>
- (void)SWMCloseTab:(id)arg;
- (void)SWMNewTabWithURL:(NSURL*)url;
@end