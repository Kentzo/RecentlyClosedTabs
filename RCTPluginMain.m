//
//  RCTPluginMain.m
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 02.02.10.
//  Copyright 2010. All rights reserved.
//

#import "RCTPluginMain.h"
#import "CustomToolbarButtonExtension.h"
#import "RCTToolbarButtonController.h"

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
        [toolbarButtonController release];
        return;
    }
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkForUpdates) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3600.0 target:self selector:@selector(checkForUpdates) userInfo:nil repeats:YES];
    
    NSLog(@"RCT did end loading");
}

+ (void)checkForUpdates {
    NSLog(@"checkForUpdates");

    NSBundle* pluginBundle = [NSBundle bundleForClass:[self class]];
    NSString* updaterPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[pluginBundle resourcePath],
                                                          @"RecentlyClosedTabs Updater.app", nil]];
    NSBundle* updaterBundle = [NSBundle bundleWithPath:updaterPath];
    
    NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString* processID = [[NSNumber numberWithInt:[[NSProcessInfo processInfo] processIdentifier]] stringValue];
    NSString* pathToRelaunch = [[NSBundle mainBundle] bundlePath];
    NSLog(@"bundleIdentifier: %@\nprocessID: %@\npathToRelaunch: %@", bundleIdentifier, processID, pathToRelaunch);
    [NSTask launchedTaskWithLaunchPath:[updaterBundle executablePath] 
                             arguments:[NSArray arrayWithObjects:bundleIdentifier, processID, pathToRelaunch, @"--background", nil]];
}

@end

