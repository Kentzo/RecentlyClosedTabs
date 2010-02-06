//
//  SWMPluginController.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SWMPluginController : NSObject {
	NSMutableArray* windowsHistory;
}
@property (retain) NSMutableArray* windowsHistory;

- (void)safariWindowWillClose:(NSNotification*)notification;

@end
