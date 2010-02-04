#import <Foundation/Foundation.h>

/*!
    @category NSNull (ObjectOrNull)
    @discussion  Gives methods to create NSNull objects from any types.
*/
@interface NSNull (ObjectOrNull)
/*!
    @method objectOrNull:
	@param theObject An object which can be nil.
	@result If the object is not nil will return it. Otherwise returns [NSNull null] object.
    @abstract Creates [NSNull null] object if theObject is nil.
    @discussion Use this method to avoid complex if-else constuctions.
*/
+ (id) objectOrNull:(id)theObject;

@end
