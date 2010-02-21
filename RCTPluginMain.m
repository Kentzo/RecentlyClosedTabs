//
//  SWMPlugin.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RCTPluginMain.h"
#import "CustomToolbarButtonExtension.h"
#import "RCTToolbarButtonController.h"

static RCTPluginMain* g_sharedPluginLoader = nil;

@implementation RCTPluginMain

+ (void)load {
	NSError* error = nil;
	
	
	RCTToolbarButtonController* toolbarButtonController = [RCTToolbarButtonController new];
	if (![CustomToolbarButtonExtension enableExtensionWithDelegate:toolbarButtonController error:&error]) {
		NSLog(@"SWMCustomToolbarButtonExtension was not loaded: %@", error);
	}
	else {
		NSLog(@"SWMCustomToolbarButtonExtension was loaded");
	}
	
	if (![DetectClosingTabExtension enableExtensionWithDelegate:toolbarButtonController error:&error]) {
		NSLog(@"SWMDetectClosingTabExtension was not loaded: %@", error);
	}
	else {
		NSLog(@"SWMDetectClosingTabExtension was loaded");
	}
	
}

#pragma mark Singleton
+ (RCTPluginMain*)sharedInstance {
	@synchronized(self) {
		if (g_sharedPluginLoader == nil) {
			g_sharedPluginLoader = [RCTPluginMain new];
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

