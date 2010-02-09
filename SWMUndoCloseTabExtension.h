//
//  UndoCloseTabExtension.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 09.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UnallocableObject.h"
#import "Extending.h"

@interface UndoCloseTabExtension : UnallocableObject <Extending>
- (void)SWMCloseTab:(BrowserTabViewItem*)arg;
- (void)SWMNewTabWithURL:(NSURL*)url;
@end
