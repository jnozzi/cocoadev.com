

Part of the iPhone [[UIKit]] framework.

%%BEGINCODESTYLE%%+ (id)applicationImageNamed:([[NSString]]'')name;%%ENDCODESTYLE%%

Instatiates the image from the application directory.

%%BEGINCODESTYLE%%- (void)compositeToPoint:([[CGPoint]])p operation:(int)operation;%%ENDCODESTYLE%%

Composites the image into the current drawing context. Is operation same as [[NSCompositingOperation]]?

%%BEGINCODESTYLE%%- ([[CGSize]])size;%%ENDCODESTYLE%%

Crashes.

----

I've been trying to find out how to draw an [[UIImage]] rotated 90�/-90�, but since you can't use (i think) [[AppKit]] you can't use whole of [[NSAffineTransform]] which makes it difficult. Any ideas on how to draw an [[UIImage]] rotated?

----

I think you should be able to just go down into [[CoreGraphics]] and do this: http://developer.apple.com/documentation/[[GraphicsImaging]]/Reference/[[CGAffineTransform]]/Reference/reference.html

Prolly not the answer you were looking for, but that's about the only thing I can come up with.

-- Jacob

----

The simplest method to rotate a [[UIImage]] is to use a [[CGAffineTransform]] and rotate its view. The nice thing is on the iPhone OS there are some convenience methods to do this, so the result looks something like this:
<code>
	[[CGAffineTransform]] rotate = [[CGAffineTransformMakeRotation]](1.57079633);
	[myImageView setTransform:rotate];
</code>

The [[CGAffineTransformMakeRotation]] takes a float in radians, so this example will rotate the image 90&#730; clockwise.

-- Pelted

Better to use M_PI_2, no?