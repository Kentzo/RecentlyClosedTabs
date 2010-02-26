//
//  SWMPlugin.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UnallocableObject.h>

@class SUUpdater;

@interface RCTPluginMain : UnallocableObject
+ (SUUpdater*)pluginUpdater;
@end