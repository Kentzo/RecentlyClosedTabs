//
//  SWMTextFieldCell.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 14.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SWMTextFieldCell : NSTextFieldCell
- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
@end
