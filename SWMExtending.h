/*
 *  SWMExtending.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 06.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@protocol SWMExtending
+ (BOOL)loadExtension:(NSError**)error;
+ (void)unloadExtension;
@end