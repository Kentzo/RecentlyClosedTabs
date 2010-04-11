/*
 *  Extending.h
 *  SafariWindowManager
 *
 *  Created by Ilya Kulakov on 06.02.10.
 *  Copyright 2010. All rights reserved.
 *
 */

@protocol BaseExtending
@required
+ (void)disableExtension;
+ (BOOL)isEnabled;
+ (Class)extendedClass;

@end

@protocol DecoratorExtending <BaseExtending>
@required
+ (BOOL)enableExtension:(NSError**)error;
@end

@protocol DelegateExtending <BaseExtending>
@required
+ (BOOL)enableExtensionWithDelegate:(id<NSObject>)delegate error:(NSError**)error;
@end