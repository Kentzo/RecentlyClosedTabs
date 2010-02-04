#import "NSNull+ObjectOrNull.h"


@implementation NSNull (ObjectOrNull)

+ objectOrNull:(id)theObject {
	id result = (theObject == nil) ? [self null] : theObject;
	return result;
}

@end
