/*
 *  SWMExtending.h
 *  SafariWindowManager
 *
 *  Created by Илья Кулаков on 06.02.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@protocol BaseExtending
@required
+ (void)disableExtension;
+ (BOOL)isEnabled;
+ (Class)extendedClass;

@end

@protocol DecoratorExtending <BaseExtending>
+ (BOOL)enableExtension:(NSError**)error;
@end

@protocol DelegateExtending <BaseExtending>
+ (BOOL)enableExtensionWithDelegate:(id<NSObject>)delegate error:(NSError**)error;
@end