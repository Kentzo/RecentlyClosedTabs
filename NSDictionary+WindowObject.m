//
//  NSDictionary+WindowObject.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+WindowObject.h"


@implementation NSDictionary (WindowObject)

+ (id)windowObjectWithTabs:(NSArray*)tabs rect:(NSRect)rect level:(NSInteger)level currentTab:(NSUInteger)currentTab {
	return [self dictionaryWithObjectsAndKeys:tabs, @"tabs",
			[NSValue valueWithRect:rect], @"rect",
			[NSNumber numberWithInteger:level], @"level",
			[NSNumber numberWithUnsignedInteger:currentTab], @"currentTab", nil];
}

- (id)initWithTabs:(NSArray*)tabs rect:(NSRect)rect level:(NSInteger)level currentTab:(NSUInteger)currentTab {
	return [self initWithObjectsAndKeys:tabs, @"tabs",
			[NSValue valueWithRect:rect], @"rect",
			[NSNumber numberWithInteger:level], @"level",
			[NSNumber numberWithUnsignedInteger:currentTab], @"currentTab", nil];
}

@end
