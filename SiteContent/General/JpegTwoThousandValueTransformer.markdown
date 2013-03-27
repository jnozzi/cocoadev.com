An General/NSValueTransformer that enables bindings to use Jpeg2000 compression rather than just the raw TIFF data. 

I've hand tuned the compression parameter to show no compression artifacts for my test images. You may wish to increase it. � General/BryanWoods

    
// Jpeg2kValueTransformer
@interface Jpeg2kValueTransformer : General/NSValueTransformer

@end

//  Jpeg2kValueTransformer.m
#import "Jpeg2kValueTransformer.h"

@implementation Jpeg2kValueTransformer

+ (Class) transformedValueClass;
{
    return General/[NSData class];
}

+ (BOOL) allowsReverseTransformation;
{
    return YES;
}

- (id) transformedValue:(id)value;
{
	return General/[[NSBitmapImageRep imageRepWithData:value] General/TIFFRepresentation];
}

- (id) reverseTransformedValue:(id)value;
{
	return General/[[NSBitmapImageRep imageRepWithData:value] representationUsingType:NSJPEG2000FileType properties:General/[NSDictionary dictionaryWithObject:General/[NSNumber numberWithFloat:0.4f] forKey:@"General/NSImageCompressionFactor"]];
}

@end



Note that NSJPEG2000FileType is only available in Mac OS X v10.4 and later.

----

Some notes


* Jpeg2000 seems to works best with large (width/height) images. Small images show more compression artifacts.
* This code base can easily be used to create General/PNGValueTransformer, General/GIFValueTransformer, etc, by changing NSJPEG2000FileType appropriately. (see http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSBitmapImageRep_Class/Reference/Reference.html)
* Any value transformer made this way can open images compressed by any other value transformer because the transformedValue: just calls General/NSBitmapImageRep directly; it will open any format General/NSBitmapImageRep knows how.