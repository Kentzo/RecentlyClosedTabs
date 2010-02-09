//
//  SWMPlugin.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMPluginLoader.h"
#import "SWMUndoCloseTabExtension.h"
#import "SWMCustomToolbarButtonExtension.h"
#import "SWMPluginController.h"

static SWMPluginLoader* g_sharedPluginLoader = nil;

@implementation SWMPluginLoader

+ (void)load {
	NSError* error = nil;
	
	[SWMUndoCloseTabExtension enableExtension:&error];
	[SWMCustomToolbarButtonExtension enableExtensionWithDelegate:[SWMPluginController sharedInstance] error:&error];
	
//	[SWMPluginController new];

//	if ([BrowserWindowControllerExtension enableExtension:&error] == NO) {
//		NSLog(@"SWMPlugin was NOT loaded: cannot load BrowserWindowControllerExtension\n%@", error);
//		return;
//	}
//	
//	if ([BrowserDocumentControllerExtension enableExtension:&error] == NO) {
//		NSLog(@"SWMPlugin was NOT loaded: cannot load BrowserDocumentControllerExtension\n%@", error);
//		return;
//	}
//	
//	if ([BrowserWindowExtension enableExtension:&error] == NO) {
//		NSLog(@"SWMPlugin was NOT loaded: cannot load BrowserWindowExtension\n%@", error);
//		return;
//	}
//	
//	if ([CustomToolBarButtonExtension enableExtension:&error] == NO) {
//		NSLog(@"SWMPlugin was NOT loaded: cannot load ToolbarControllerExtension\n%@", error);
//		return;
//	}
	
	NSLog(@"SWMPlugin was loaded");
}

#pragma mark Singleton
+ (SWMPluginLoader*)sharedInstance {
	@synchronized(self) {
		if (g_sharedPluginLoader == nil) {
			g_sharedPluginLoader = [SWMPluginLoader new];
		}
	}
	return g_sharedPluginLoader;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (g_sharedPluginLoader == nil) {
            g_sharedPluginLoader = [super allocWithZone:zone];
            return g_sharedPluginLoader;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}
- (void)release {
    //do nothing
}
- (id)autorelease {
    return self;
}

@end

