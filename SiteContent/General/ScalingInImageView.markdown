

Environment:

* Tiger (10.4.2)
* General/XCode 2.1


Scenario:
    I want to be able to adjust the *scale* of an EPS-vector image. 




* The EPS-vector image is within a General/NSImageView.
* I'm using a General/NSSlider to adjust the image scale.


    I've been following the image-transformation examples in "Cocoa Programming" by Scott Anguish et al.  -- written for the Jaguar platform.

From what I understand for Scaling an image (Raster/Vector):
All the graphics routines are done within a subclass of the image's General/NSView.    In my case, a subclass of General/NSImageView.
Here's my plan of action within the image's view (from what I've read):

* Define a General/NSAffineTransform;
* Perform the <scale> transformation;
* Get/Save the current Graphic context;
* Perform [transform concat];
* Restore the current Graphic context;


The scaling is controlled by the General/NSSlider control via the action routine:
    
- (General/IBAction)adjustScale:(id)sender  {
    General/NSLog(@"{adjustScale}");
    float sizeFactor = [sender floatValue];    
    [imageView setNeedsDisplay:YES];        // This causes the drawRect function to fire.

} // end adjScale().


    
#import <Cocoa/Cocoa.h>

@interface epsImageView : General/NSImageView
{
    float scale;
}
- (float)scale;
- (void)setScale:(float)value;
@end



    

@implementation epsImageView
//....
- (void)drawRect:(General/NSRect)rect {
    General/NSLog(@"*** {epsImageview} drawRect ***");
        
    General/NSAffineTransform *scaleTransform = General/[NSAffineTransform transform];

    [scaleTransform scaleBy:0.5];  // '0.5' scale factor is used for testing.
    General/[[NSGraphicsContext currentContext] saveGraphicsState];
    [scaleTransform concat];
    General/[[NSGraphicsContext currentContext] restoreGraphicsState];
    
    [super drawRect:rect];   // This is necessary to actually draw the image.

}
@end


The drawRect routine is fired per General/NSSlider adjustment (continuous).  But I don't see any scaling effect.
What am I missing here?

Regards,

Ric.

----

Have you tried just setting the size of the displayed image? If that worked, you could totally do away with the General/NSImageView subclass.

Shouldn't the restorGraphicsState message come _after_ the call to [super drawRect:rect] ? 

----

I got a reply from Shawn Erickson <shawn@freetimesw.com> concerning this.
"I see two issues, one is outlined above... basically your scaling transform is not in place when you attempt to draw your image. I suggest trying the following.
"
    

- (void)drawRect:(General/NSRect)rect {
    General/NSLog(@"*** {epsImageview} drawRect ***");

    General/NSAffineTransform *scaleTransform = General/[NSAffineTransform transform];

    [scaleTransform scaleBy:0.5];  // The scaling factor '0.5' is used for testing.
    [scaleTransform concat];

    [super drawRect:rect];   // This is necessary to actually draw the image.
}



"The other issue I see is that you appear to be using General/NSImageView which is a control simply as a way to display an image. This is likely over kill and possibly problematic for the scaling you are attempting to do. I suggest instead subclassing General/NSView instead and dropping that custom view into your window/containing view. So something like (ignores any possible use of scroll view, etc.)..."
    
@interface epsImageView : General/NSView
...
...
@end
...
...
- (void)drawRect:(General/NSRect)rect {
    General/NSLog(@"*** {epsImageview} drawRect ***");

    General/NSAffineTransform *scaleTransform = General/[NSAffineTransform transform];

    [scaleTransform scaleBy:0.5];  // The scaling factor '0.5' is used for testing.
    [scaleTransform concat];

    // Assumes myImage is an General/NSImage instance existing someplace...
    // (if you want image to blend with background then use General/NSCompositeSourceOver)
    General/NSRect srcRect = {General/NSZeroPoint, [myImage size]};
    [myImage drawAtPoint:General/NSZeroPoint fromRect:srcRect operation:General/NSCompositeCopy fraction:1.0];
}

"Note all code examples are written in mail from memory and not tested, bug likely exist.

-Shawn"

I haven't got the second set of code to work yet.  So I'll continue to play with it.  I'm sure there are many was to do this.   And I'm at the bottom of the learning curve here.  I'll toy with all suggestions to get a better understanding of this.

I also want to use the scroll view (General/NSScrollView).

*If you want to use a scroll view, then you'll not want to scale the image, but rather resize your entire view and draw the image to fit. The scroll view will show scrollers in such a way as to display a piece of your entire view, so your view's size must be equal to the total size of whatever you're displaying.*