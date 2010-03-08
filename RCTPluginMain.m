//
//  SWMPlugin.m
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 02.02.10.
//  Copyright 2010. All rights reserved.
//

#import "RCTPluginMain.h"
#import "CustomToolbarButtonExtension.h"
#import "RCTToolbarButtonController.h"
#import <Sparkle/Sparkle.h>

static RCTPluginMain* g_sharedPluginLoader = nil;

@implementation RCTPluginMain

+ (void)load {
    NSLog(@"RCT will start loading");
    
	NSError* error = nil;
    RCTToolbarButtonController* toolbarButtonController = [RCTToolbarButtonController new];

	if (![CustomToolbarButtonExtension enableExtensionWithDelegate:toolbarButtonController error:&error]) {
		NSLog(@"CustomToolbarButtonExtension was not loaded: %@", error);
	}
	else {
		NSLog(@"CustomToolbarButtonExtension was loaded");
	}
	
	if (![DetectClosingTabExtension enableExtensionWithDelegate:toolbarButtonController error:&error]) {
		NSLog(@"DetectClosingTabExtension was not loaded: %@", error);
	}
	else {
		NSLog(@"DetectClosingTabExtension was loaded");
	}
    // If error is occured will disable extensions and return
    if (error != nil) {
        [CustomToolbarButtonExtension disableExtension];
        [DetectClosingTabExtension disableExtension];
        return;
    }
    
    // Enable Sparkle
    [self pluginUpdater];
    
    NSLog(@"RCT did end loading");
}

+ (SUUpdater*)pluginUpdater {
    static SUUpdater* pluginUpdater = nil;
    if (pluginUpdater == nil) {
        pluginUpdater = [[SUUpdater alloc] initForBundle:[NSBundle bundleForClass:[self class]]];
    }
    return pluginUpdater;
}

@end

