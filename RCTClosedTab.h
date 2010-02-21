//
//  SWMClosedTab.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 16.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SWMClosedTab : NSObject {
	NSDate* closingTime;
	NSString* title;
	NSURL* url;
	NSImage* favicon;
}
@property (copy) NSDate* closingTime;
@property (copy) NSString* title;
@property (copy) NSURL* url;
@property (copy) NSImage* favicon;

- initWithTitle:(NSString*)theTitle url:(NSURL*)theUrl date:(NSDate*)theDate favicon:(NSImage*)theFavicon;

@end
