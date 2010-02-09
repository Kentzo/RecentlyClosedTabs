/*
 *  SWMExtending.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 06.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@protocol Extending
@required
+ (BOOL)enableExtension:(NSError**)error;
+ (void)disableExtension;
+ (BOOL)isEnabled;
+ (Class)extendedClass;

@end