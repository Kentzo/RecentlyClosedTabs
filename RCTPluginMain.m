//
//  SWMPlugin.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMPluginLoader.h"
#import "SWMCustomToolbarButtonExtension.h"
#import "SWMToolbarButtonController.h"

static SWMPluginLoader* g_sharedPluginLoader = nil;

@implementation SWMPluginLoader

+ (void)load {
	NSError* error = nil;
	
	
	SWMToolbarButtonController* toolbarButtonController = [SWMToolbarButtonController new];
	if (![SWMCustomToolbarButtonExtension enableExtensionWithDelegate:toolbarButtonController error:&error]) {
		NSLog(@"SWMCustomToolbarButtonExtension was not loaded: %@", error);
	}
	else {
		NSLog(@"SWMCustomToolbarButtonExtension was loaded");
	}
	
	if (![SWMDetectClosingTabExtension enableExtensionWithDelegate:toolbarButtonController error:&error]) {
		NSLog(@"SWMDetectClosingTabExtension was not loaded: %@", error);
	}
	else {
		NSLog(@"SWMDetectClosingTabExtension was loaded");
	}
	
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

