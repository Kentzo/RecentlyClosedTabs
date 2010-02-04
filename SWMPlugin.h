//
//  SWMPlugin.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 02.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWMPlugin : NSObject {
}
+ (SWMPlugin*)sharedPlugin;

- (void)safariWindowWillClose:(NSNotification *)notification;

@end
