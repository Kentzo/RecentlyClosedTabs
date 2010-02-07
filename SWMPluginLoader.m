//
//  SWMPlugin.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMPluginLoader.h"
#import "DumpedSafariHeaders+Extensions.h"
#import "SWMPluginController.h"

@implementation SWMPluginLoader

+ (void)load {
	NSError* error = nil;

	if ([BrowserWindowControllerExtension loadExtension:&error] == NO) {
		NSLog(@"SWMPlugin was NOT loaded: cannot load BrowserWindowControllerExtension\n%@", error);
		return;
	}
	
	if ([BrowserDocumentControllerExtension loadExtension:&error] == NO) {
		NSLog(@"SWMPlugin was NOT loaded: cannot load BrowserDocumentControllerExtension\n%@", error);
	}
	
	if ([BrowserWindowExtension loadExtension:&error] == NO) {
		NSLog(@"SWMPlugin was NOT loaded: cannot load BrowserWindowExtension\n%@", error);
	}
	
	[SWMPluginController new];
	
	NSLog(@"SWMPlugin was loaded");
}

+ (id)alloc {
	return nil;
}
+ (id)allocWithZone:(NSZone *)zone {
	return nil;
}

@end

