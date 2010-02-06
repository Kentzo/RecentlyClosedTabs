//
//  NSDictionary+WindowObject.h
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDictionary (WindowObject)

+ (id)windowObjectWithTabs:(NSArray*)tabs rect:(NSRect)rect level:(NSInteger)level currentTab:(NSUInteger)currentTab;

- (id)initWithTabs:(NSArray*)tabs rect:(NSRect)rect level:(NSInteger)level currentTab:(NSUInteger)currentTab;

@end
