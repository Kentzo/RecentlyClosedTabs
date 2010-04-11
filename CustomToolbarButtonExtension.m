//
//  RCTCustomToolbarButtonExtension.m
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 09.02.10.
//  Copyright 2010. All rights reserved.
//

#import "CustomToolbarButtonExtension.h"
#import "JRSwizzle.h"
#import "Runtime.h"

@implementation CustomToolbarButtonExtension

static CFStringRef const g_BrowserToolbarItemsIdentifiers = (CFStringRef)@"BrowserToolbarItemsIdentifiers";
static BOOL g_CustomToolbarButtonExtension_Enabled = NO;
static id<CustomToolbarButtonExtensionDelegate> g_CustomToolbarButtonExtension_Delegate = nil;

#pragma mark Extending
+ (BOOL)enableExtensionWithDelegate:(id<NSObject, CustomToolbarButtonExtensionDelegate>)delegate error:(NSError**)error {
	static BOOL g_CustomToolbarButtonExtension_Initialized = NO;
	if (!g_CustomToolbarButtonExtension_Initialized) {
		Class origClass = [self extendedClass];
		class_addMethodsFromClass(origClass, self);
		g_CustomToolbarButtonExtension_Delegate = delegate;
		g_CustomToolbarButtonExtension_Enabled = [origClass jr_swizzleMethod:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:)
															 withMethod:@selector(RCTToolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:)
																  error:error] &&
												[origClass jr_swizzleMethod:@selector(toolbarAllowedItemIdentifiers:) 
															withMethod:@selector(RCTToolbarAllowedItemIdentifiers:) 
																 error:error];
		
		// Get toolbar object
		NSDocumentController* documentContr = [NSDocumentController sharedDocumentController];
		BrowserWindowController* windowContr = [[[documentContr documents] objectAtIndex:0] browserWindowController];
		BrowserToolbar* toolbar = [[windowContr window] toolbar];
        
        // Get identifier of our item from delegate
		NSString* itemIdentifier = [g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar];
		
        // Get list of toolbar items identifiers
        CFStringRef bundleIdentifier = (CFStringRef)[[NSBundle bundleForClass:[self class]] bundleIdentifier];
        CFPreferencesAppSynchronize(bundleIdentifier);
        NSArray* allIdentifiers = (NSArray*)CFPreferencesCopyAppValue(g_BrowserToolbarItemsIdentifiers, bundleIdentifier);
        if (allIdentifiers != NULL) {
            [(id)CFMakeCollectable(allIdentifiers) autorelease];
            
            // Get index of our button on toolbar
            NSUInteger index = [allIdentifiers indexOfObject:itemIdentifier];
            if (index != NSNotFound) {
                NSArray* loadedIdentifiers = [toolbar valueForKeyPath:@"items.itemIdentifier"];
                // Test what items already loaded and what did not
                NSMutableArray* filtredIdents = [NSMutableArray arrayWithArray:allIdentifiers];
                [filtredIdents removeObjectsInArray:loadedIdentifiers];
                // Determine index offset for our button
                NSUInteger indexOffset = [filtredIdents indexOfObject:itemIdentifier];
                // Insert our button to the toolbar
                [toolbar _userInsertItemWithItemIdentifier:itemIdentifier
                                                   atIndex:(index - indexOffset)];
            }
        }
        
        // Add observer for userdefaults notifications
        [[NSNotificationCenter defaultCenter] addObserver:[self class] 
                                                 selector:@selector(storeToolbarItemIdentifiers:) 
                                                     name:NSUserDefaultsDidChangeNotification 
                                                   object:[NSUserDefaults standardUserDefaults]];
        
		if (g_CustomToolbarButtonExtension_Enabled)
			g_CustomToolbarButtonExtension_Initialized = YES;
	}
	else {
		g_CustomToolbarButtonExtension_Enabled = YES;
	}

	
	return g_CustomToolbarButtonExtension_Enabled;
}
+ (void)disableExtension {
	NSDocumentController* documentContr = [NSDocumentController sharedDocumentController];
	BrowserWindowController* windowContr = [[[documentContr documents] objectAtIndex:0] browserWindowController];
	BrowserToolbar* toolbar = [[windowContr window] toolbar];
	NSArray* identifiers = [toolbar valueForKeyPath:@"items.itemIdentifier"];
	NSString* buttonIdentifier = [g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar];
	
	// Remove button from the toolbar
	if ([identifiers containsObject:buttonIdentifier]) {
		[toolbar removeItemWithIdentifier:buttonIdentifier];
	}
    
    // Remove observer for userdefaults notification
    [[NSNotificationCenter defaultCenter] removeObserver:[self class] 
                                                    name:NSUserDefaultsDidChangeNotification 
                                                  object:[NSUserDefaults standardUserDefaults]];
    
	g_CustomToolbarButtonExtension_Enabled = NO;
}
+ (Class)extendedClass {
	return NSClassFromString(@"ToolbarController");
}
+ (BOOL)isEnabled {
	return g_CustomToolbarButtonExtension_Enabled;
}

- (BrowserToolbarItem*)RCTToolbar:(BrowserToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted {
	static BrowserToolbarItem* RCTToolBarItem = nil;
	
	id result = nil;
	if (g_CustomToolbarButtonExtension_Enabled &&
        [identifier isEqualToString:[g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar]]) 
    {
		// If identifier is equal to identifier in delegate will return our button
        if (RCTToolBarItem == nil) {
            // Create item only once
            NSButton* RCTButton = [g_CustomToolbarButtonExtension_Delegate toolbarButton:toolbar];
            RCTToolBarItem = [[NSClassFromString(@"BrowserToolbarItem") alloc] 
                              initWithItemIdentifier:[g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar]
                              target:g_CustomToolbarButtonExtension_Delegate
                              button:RCTButton];
            [RCTToolBarItem setAction:[g_CustomToolbarButtonExtension_Delegate toolbarButtonAction:toolbar]];
            [RCTToolBarItem setToolTip:[g_CustomToolbarButtonExtension_Delegate toolbarButtonToolTip:toolbar]];
        }
        result = RCTToolBarItem;
	}
	else
		result = [self RCTToolbar:toolbar itemForItemIdentifier:identifier willBeInsertedIntoToolbar:willBeInserted];
    
	return result;
}
- (NSArray*)RCTToolbarAllowedItemIdentifiers:(BrowserToolbar*)toolbar {
	NSArray* result = [self RCTToolbarAllowedItemIdentifiers:toolbar];
	if (g_CustomToolbarButtonExtension_Enabled)
		result = [result arrayByAddingObject:[g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar]];

    return result;
}
+ (void)storeToolbarItemIdentifiers:(NSNotification*)notification {
    // Get toolbar object
    NSDocumentController* documentContr = [NSDocumentController sharedDocumentController];
    BrowserWindowController* windowContr = [[[documentContr documents] objectAtIndex:0] browserWindowController];
    BrowserToolbar* toolbar = [[windowContr window] toolbar];
    
    // Store identifiers of toolbar items
    CFStringRef bundleIdentifier = (CFStringRef)[[NSBundle bundleForClass:[self class]] bundleIdentifier];
    CFPreferencesSetAppValue(g_BrowserToolbarItemsIdentifiers, [toolbar valueForKeyPath:@"items.itemIdentifier"], bundleIdentifier);
    CFPreferencesAppSynchronize(bundleIdentifier);
}

@end
