//
//  RCTClosedTab.h
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 16.02.10.
//  Copyright 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RCTClosedTab : NSObject {
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
