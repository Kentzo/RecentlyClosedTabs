//
//  SWMTableView.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 14.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SWMTableView : NSTableView
- (void)highlightSelectionInClipRect:(NSRect)clipRect;
@end
