I have a written a program that displays images in a General/CustomView using Core Image.  I added two General/CIFilters to it, and it started leaking memory.  I believe this is because I am retaining the filters, and not releasing them.  However when I try to release both filters and the image, my program crashes.  The relevant code from my General/CustomView follows:

    
- (void)setImage: (General/CIImage*)image {
        originalImage = image;
        [originalImage retain];
        if(sharpenFilter == nil) {
                sharpenFilter   = General/[CIFilter filterWithName: @"General/CISharpenLuminance"
                                                                         keysAndValues: @"inputImage", originalImage, nil];
                [sharpenFilter setValue:General/[[NSNumber alloc] initWithFloat:0.0] forKey:@"inputSharpness"];
                [sharpenFilter retain];
        }
        if(contrastFilter == nil) {
                contrastFilter = General/[CIFilter filterWithName: @"General/CIHueAdjust"
                                                                        keysAndValues:@"inputImage", originalImage, nil];
                [contrastFilter setValue:General/[[NSNumber alloc] initWithFloat:0.0] forKey:@"inputAngle"];
                [contrastFilter retain];
        }
}

- (void)dealloc {
        [sharpenFilter release];
        [contrastFilter release];
        [originalImage release];

        [super dealloc];
}


Interestingly, I can release any one of the objects in my dealloc method, but if I try to do two or more, it crashes.
Can someone straighten out my memory management?

----

*Not without you telling us what line fails. Seriously, you can't expect help by saying 'one of the objects'. Tell us exactly what line crashes. You can use the debugger to do so. Set a breakpoint in your dealloc method and step through. Tell us what error you receive (just to make sure).*

----

I literally meant "any" of the objects, if I do more than one, not just one in general.  Nevertheless, when running the code above, here's some more info:
The error I get is: Program received signal: "EXC_BAD_ACCESS"
It comes from the line [contrastFilter release].  However as I mentioned, if I release the contrastFilter first, it is fine, but then the sharpenFilter will crash when I release it.  The same goes for the originalImage, if it is released first it is fine, but if it is second in line, it will crash.
Here is the relevant stack trace:


    
#0      0xfffeff20 in objc_msgSend_rtp
#1      0x9285f708 in General/NSPopAutoreleasePool
#2      0x9422abac in -General/[CIFilter dealloc]
#3      0x0003f7c4 in -General/[MyCIView dealloc] at General/MyCIView.m:69


*Please post all the relevant code for "General/MyCIView" ... the initialization routine and any routines that use the three ivars referenced above.*

----

You have a memory leak in the first line of     setImage:. Your are setting     originalImage without releasing     originalImage if it has already been set from a previous call to this method. --zootobbalu

*Well that's certainly *a* problem, but not *the* problem. :-)* 

----
I am only ever calling that method once, but I will update that in the future.

Here's the class in it's entirety:

    

#import "General/MyCIView.h"
#import <Foundation/General/NSDictionary.h>

enum {
	General/MCContrast, General/MCSharpen
};

@implementation General/MyCIView

- (id)initWithFrame:(General/NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		lastFilter = General/MCSharpen;
    }
    return self;
}

- (void)setContrast:(float)value;
{
	General/NSLog(@"Value set to: %f", value);
	if(lastFilter != General/MCContrast)
		[contrastFilter setValue:originalImage forKey:@"inputImage"];
	lastFilter = General/MCContrast;
	[contrastFilter setValue:General/[[NSNumber alloc] initWithFloat:value] forKey:@"inputAngle"];
	[self setNeedsDisplay:YES];
}

- (void)setSharpness:(float)value;
{
	General/NSLog(@"Value set to: %f", value);
	if(lastFilter != General/MCSharpen)
		[sharpenFilter setValue:originalImage forKey:@"inputImage"];
	lastFilter = General/MCSharpen;
	[sharpenFilter setValue:General/[[NSNumber alloc] initWithFloat:value] forKey:@"inputSharpness"];
	[self setNeedsDisplay:YES];
}

- (void)setImage: (General/CIImage*)image {
	originalImage = image;
	[originalImage retain];
	if(sharpenFilter == nil) {
		sharpenFilter   = General/[CIFilter filterWithName: @"General/CISharpenLuminance"
									 keysAndValues: @"inputImage", originalImage, nil];
		[sharpenFilter setValue:General/[[NSNumber alloc] initWithFloat:0.0] forKey:@"inputSharpness"];
		[sharpenFilter retain];
	}
	if(contrastFilter == nil) {
		contrastFilter = General/[CIFilter filterWithName: @"General/CIHueAdjust"
									keysAndValues:@"inputImage", originalImage, nil];
		[contrastFilter setValue:General/[[NSNumber alloc] initWithFloat:0.0] forKey:@"inputAngle"];
		[contrastFilter retain];
	}
}

- (void)dealloc {
	[contrastFilter release];
	[sharpenFilter release];
	[originalImage release];

	[super dealloc];
}

- (void)drawRect:(General/NSRect)rect {
	General/CGRect cg = General/CGRectMake(General/NSMinX(rect), General/NSMinY(rect), General/NSWidth(rect), General/NSHeight(rect));
	General/CIContext* context = General/[[NSGraphicsContext currentContext] General/CIContext];
	
	if (context != nil) {
		switch(lastFilter) {
			case General/MCContrast:
				[context drawImage: [contrastFilter valueForKey:@"outputImage"]
									   atPoint: cg.origin fromRect: cg];
				break;
			case General/MCSharpen:
				[context drawImage: [sharpenFilter valueForKey:@"outputImage"]
						   atPoint: cg.origin fromRect: cg];
				break;
			default:
				[context drawImage:originalImage
						   atPoint: cg.origin fromRect: cg];
		}
	}
	
}

@end



*In practice you should set your ivars (such as the filter, image, etc.) to nil in your initialization routine.*

This is not true in General/ObjectiveC. The runtime sets (and is documented to set) all of your instance variables to 0/nil/NULL/0.0 when your object is created.

----

I have solved my own problem.  The argument I was passing into the setImage method was being autoreleased in the previous method.  So once it got into setImage, it's retain count would have already been decremented by the autorelease.  The retain call within setImage then sets the retainCount to 1 and finally when my method called release on it, the retainCount dropped to 0 and it released it not only in General/MyCIView, but in the previous method as well.  Then when something else attempts to access it, it would crash.  Or at least that's how I believe it occurred.