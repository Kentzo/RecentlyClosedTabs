//
//  SWMCustomToolbarButtonExtension.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 09.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMCustomToolbarButtonExtension.h"
#import "JRSwizzle.h"
#import "Runtime.h"

@implementation SWMCustomToolbarButtonExtension

static BOOL g_CustomToolbarButtonExtension_Enabled = FALSE;
static id<SWMCustomToolbarButtonExtensionDelegate> g_CustomToolbarButtonExtension_Delegate = nil;

#pragma mark Extending
+ (BOOL)enableExtensionWithDelegate:(id<NSObject, SWMCustomToolbarButtonExtensionDelegate>)delegate error:(NSError**)error {
//	NSAssert([delegate conformsToProtocol:@protocol(SWMCustomToolbarButtonExtensionDelegate)],
//			 @"Delegate must conform SWMCustomToolbarButtonExtensionDelegate protocol");
	Class origClass = [self extendedClass];
	class_addMethodsFromClass(origClass, self);
	g_CustomToolbarButtonExtension_Delegate = delegate;
	g_CustomToolbarButtonExtension_Enabled = [origClass jr_swizzleMethod:@selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:) 
													  withMethod:@selector(SWMToolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:) error:error] &&
									 [origClass jr_swizzleMethod:@selector(toolbarAllowedItemIdentifiers:) 
													  withMethod:@selector(SWMToolbarAllowedItemIdentifiers:) error:error];
	
	// Get toolbar object
	NSDocumentController* documentContr = [NSDocumentController sharedDocumentController];
	BrowserWindowController* windowContr = [[[documentContr documents] objectAtIndex:0] browserWindowController];
	BrowserToolbar* toolbar = [[windowContr window] toolbar];
	
	NSString* itemIdentifier = [g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar];
	NSAssert(itemIdentifier != nil, @"Cannot get item identifier for current toolbar");
	
	// Load toolbar item data from defaults
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary* configuration = [defaults dictionaryForKey:@"NSToolbar Configuration BrowserWindowToolbarIdentifier"];
	NSArray* allIdentifiers = [configuration objectForKey:@"TB Item Identifiers"];
	NSUInteger index = [allIdentifiers indexOfObject:itemIdentifier];
	NSLog(@"index is %i", index);
	if (index != NSNotFound) {
		NSArray* loadedIdentifiers = [toolbar valueForKeyPath:@"items.itemIdentifier"];
		// Test what items already loaded and what did not
		NSMutableArray* filtredIdents = [NSMutableArray arrayWithArray:allIdentifiers];
		[filtredIdents removeObjectsInArray:loadedIdentifiers];
		// Determine index offset for our button
		NSUInteger indexOffset = [filtredIdents indexOfObject:itemIdentifier];
		NSLog(@"index offset is %i", indexOffset);
		// Insert our button to the toolbar
		[toolbar _userInsertItemWithItemIdentifier:itemIdentifier
										   atIndex:(index - indexOffset)];
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
	g_CustomToolbarButtonExtension_Enabled = FALSE;
}
+ (Class)extendedClass {
	return NSClassFromString(@"ToolbarController");
}
+ (BOOL)isEnabled {
	return g_CustomToolbarButtonExtension_Enabled;
}

- (BrowserToolbarItem*)SWMToolbar:(BrowserToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted {
	static BrowserToolbarItem* SWMToolBarItem = nil;
	
	id result = nil;
	if (g_CustomToolbarButtonExtension_Enabled) {
		if (SWMToolBarItem == nil) {
			// Create item only once
			NSButton* SWMButton = [g_CustomToolbarButtonExtension_Delegate toolbarButton:toolbar];
			SWMToolBarItem = [[NSClassFromString(@"BrowserToolbarItem") alloc] 
							  initWithItemIdentifier:[g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar]
							  target:self
							  button:SWMButton];
		}
		
		// If identifier is equal to identifier in delegate will return our cursom item
		if ([identifier isEqualToString:[g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar]])
			result = SWMToolBarItem;
		else
			result = [self SWMToolbar:toolbar itemForItemIdentifier:identifier willBeInsertedIntoToolbar:willBeInserted];
	}
	else
		result = [self SWMToolbar:toolbar itemForItemIdentifier:identifier willBeInsertedIntoToolbar:willBeInserted];
	
	return result;
}
- (NSArray*)SWMToolbarAllowedItemIdentifiers:(BrowserToolbar*)toolbar {
	NSArray* result = [self SWMToolbarAllowedItemIdentifiers:toolbar];
	if (g_CustomToolbarButtonExtension_Enabled) {
		return [result arrayByAddingObject:[g_CustomToolbarButtonExtension_Delegate toolbarButtonIdentifier:toolbar]];
	}
	else {
		return result;
	}
}

@end
