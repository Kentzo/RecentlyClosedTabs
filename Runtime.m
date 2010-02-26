/*
 *  Runtime.c
 *  SafariWindowManager
 *
 *  Created by Ilya Kulakov on 09.02.10.
 *  Copyright 2010. All rights reserved.
 *
 */

#import "Runtime.h"

void class_addMethodsFromClass(Class dest, Class source) {
	// Get method list of source class
	unsigned int list_size;
	Method* methodList = class_copyMethodList(source, &list_size);
	
	// Add methods from the list to dest class
	for(; list_size > 0; --list_size) {
		Method meth = methodList[list_size - 1];
		SEL sel = method_getName(meth);
		const char* encod = method_getTypeEncoding(meth);
		IMP imp = class_getMethodImplementation(source, sel);
		class_addMethod(dest, sel, imp, encod);
	}
}