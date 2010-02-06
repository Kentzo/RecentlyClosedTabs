//
//  NSDictionary+TabObject.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDictionary (TabObject)

+ (id)tabWithTitle:(NSString*)title url:(NSURL*)url;

- (id)initWithTitle:(NSString*)title url:(NSURL*)url;

@end
