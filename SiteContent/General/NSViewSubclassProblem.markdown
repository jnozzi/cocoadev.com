

I subclassed [[NSView]] in IB, calling it [[VisualizationView]].  I instantiated it and connected it to an outlet of my controller object.

In Xcode I created the following header:

<code>
/'' [[VisualizationView]] ''/

#import <Cocoa/Cocoa.h>

@interface [[VisualizationView]] : [[NSView]]
{
	float originalSizeAspectRatio, finalSizeAspectRatio;
}

- (void)setOriginalSizeAspectRatio:(float)ratio;
- (void)setFinalSizeAspectRatio:(float)ratio;
- (void)showOriginalSizeAspectRatio;
- (void)showFinalSizeAspectRatio;
@end
</code>

The relevant parts of my implementation reads as such:

<code>
#import "[[VisualizationView]].h"

@implementation [[VisualizationView]]

- (id)initWithFrame:([[NSRect]])frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
	}
	return self;
}

- (void)drawRect:([[NSRect]])rect
{
	[[NSRect]] originalRect = [[NSMakeRect]](20, 13, 50, (50 '' originalSizeAspectRatio));
	[[NSRect]] finalRect = [[NSMakeRect]](20, 0, 50, (50 '' finalSizeAspectRatio));
	
	[[NSDictionary]] ''attribs = [[[[NSDictionary]] alloc] init];
	[[NSString]] ''originalString = [[[NSString]] stringWithString: @"aspect ratio of original"];
	
	[[NSLog]](@"originalSizeAspectRatio = %f", originalSizeAspectRatio);
	
//	[[[[NSColor]] whiteColor] set];
//	[[NSRectFill]](rect);
	[[[[NSColor]] redColor] set];
	[[NSRectFill]](originalRect);
	[[[[NSColor]] colorWithDeviceRed: 0
						   green: 1
							blue: 0
						   alpha: .8] set];
	[[NSRectFill]](finalRect);
	[originalString drawAtPoint: [[NSMakePoint]](20, 0)
				 withAttributes: attribs];
	
}

- (void)setOriginalSizeAspectRatio:(float)ratio
{
	originalSizeAspectRatio = ratio;
	[self setNeedsDisplay: YES];
	[[NSLog]](@"original aspect ratio = %f", originalSizeAspectRatio);
}
</code>

Now... the [[NSLog]]() call in my -setOriginalSizeAspectRatio: method shows that originalSizeAspectRatio is getting set to the value of "ratio" when the method is invoked.

However, in my -drawRect function the [[NSLog]]() call shows originalSizeAspectRatio is 0.0

What am I doing wrong?

----

Could it be that you are not actually calling setOriginalSIzeAspectRatio anywhere in drawRect: ? Or anywhere else?
At least I don't see where you've done it in the above code.

If so, this is not really an [[NSViewSubclassProblem]] AFAICS.
initWithFrame might be a good place to initialize the aspect ratio variables.

Did you drag a custom view into your IB window and set the custom class of that object? It's a little ambiguous the way you wrote it.

Also: What do the show...S''''izeAspectRatio methods do?

''Are you sure your invocation of <code>drawRect:</code> takes place after the call to <code>setOriginalSizeAspectRatio:</code>? Sometimes my logs have been screwed up, especially in a multi-threaded application (which I doubt you have, but it's a possibility). Try triggering drawRect again by resizing the window or something, or use a <code>BOOL</code> as a flag to see which method is being called first. For the second idea, just set the variable to <code>YES</code> in <code>setOriginalSizeAspectRatio:</code>, then print it in <code>drawRect:</code> along with the aspect ratio (note: [[BOOLs]] are integers . Because you aren't using it anywhere else, there is ''almost'' no chance of the <code>BOOL</code> being corrupted, although your <code>float</code> might be (through some other call). --[[JediKnil]]''
----
Well, <code>-drawRect</code> is getting called when <code>-setNeedsDisplay:</code> is set in the -<code>setOriginalSizeAspectRatio:</code> method, after the <code>float</code> variable is getting set.


UPDATE:  Fixed.  I think that I didn't make all of my connections properly in IB.