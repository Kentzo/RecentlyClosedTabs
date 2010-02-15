//
//  SWMToolbarButtonController.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 15.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SWMCustomToolbarButtonExtension.h"


@interface SWMToolbarButtonController : NSObject <SWMCustomToolbarButtonExtensionDelegate> {
	NSButton* toolbarButton;
}

- (void)toolbarButtonClicked;
@end
