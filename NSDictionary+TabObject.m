//
//  NSDictionary+TabObject.m
//  SafariWindowManager
//
//  Created by Илья Кулаков on 06.02.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+TabObject.h"


@implementation NSDictionary (TabObject)

+ (id)tabWithTitle:(NSString*)title url:(NSURL*)url {
	return [self dictionaryWithObjectsAndKeys:title, @"title",
			url, @"url", nil];
}

- (id)initWithTitle:(NSString*)title url:(NSURL*)url {
	return [self initWithObjectsAndKeys:title, @"title",
			url, @"url", nil];
}

@end
