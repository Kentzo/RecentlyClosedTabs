//
//  SWMPlugin.h
//  SafariWindowManager
//
//  Created by Ilya Kulakov on 02.02.10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUUpdater;

@interface RCTPluginMain : NSObject
+ (SUUpdater*)pluginUpdater;
@end
