//
//  SWMClosedTab.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SWMClosedTab.h"


@implementation SWMClosedTab
@synthesize closingTime;
@synthesize title;
@synthesize url;
@synthesize favicon;

- initWithTitle:(NSString*)theTitle url:(NSURL*)theUrl date:(NSDate*)theDate favicon:(NSImage*)theFavicon {
	if (self = [super init]) {
		self.title = theTitle;
		self.url = theUrl;
		self.closingTime = theDate;
		self.favicon = theFavicon;
	}
	return self;
}

- (void)dealloc {
	[closingTime release];
	[title release];
	[url release];
	[favicon release];
	[super dealloc];
}

- (BOOL)isEqual:(SWMClosedTab*)object {
	return [self.url isEqual:object.url];
}

- (NSString*)description {
	return [NSString stringWithFormat:@"title: %@, url: %@, closingTime: %@, favicon: %@", title, url, closingTime, favicon];
}

@end
