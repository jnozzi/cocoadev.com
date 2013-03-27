I'm trying to learn how to draw to a view.  This simple code just takes values from 4 General/NSTextFields and attempts to fill a General/MyTextView object with white, then draws a square of the color specified in CMYK from the General/NSTextFields.  An General/NSButton is connected to a "go:" action to get it going.

My drawRect: method fires when the program first launches, but not when I enter values in the General/NSTextFields and hit "go".

Am I improperly using setNeedsDisplay: in my go: method?  I've used General/NSLog to see that values are right at various points in the process.  I left an General/NSLog in the drawRect method that shows it's getting called only once.

Clearly there is much I don't understand about drawing in Cocoa, but I'm trying to piece together little routines so that I might better understand what's going on.

Thanks for any and all help.

    
/* General/MyTextView */

#import <Cocoa/Cocoa.h>

@interface General/MyTextView : General/NSTextView

     {
	     General/IBOutlet General/NSTextField *cyan;
      	     General/IBOutlet General/NSTextField *magenta;
	     General/IBOutlet General/NSTextField *yellow;
	     General/IBOutlet General/NSTextField *black;
	
	     float convertedCyan, convertedMagenta, convertedYellow, convertedBlack;
     }
     - (BOOL)isOpaque;
     - (float)convertValue:(float)clr;
     - (General/IBAction)go:(id)sender;

@end

#import "General/MyTextView.h"

@implementation General/MyTextView


- (void)drawRect: (General/NSRect)aRect
{
		
	General/NSLog(@"---> %f, %f, %f, %f", convertedCyan, convertedMagenta, convertedYellow, convertedBlack);
	
	// make the view background white
	General/[[NSColor whiteColor] set];
	General/[NSBezierPath fillRect:aRect];
	
	// display a square of color on the white background
	General/NSColor *theColor = General/[NSColor colorWithDeviceCyan: convertedCyan magenta: convertedMagenta yellow:convertedYellow black:convertedBlack alpha: 1.0];
	[theColor set];
	General/NSRectFill(General/NSMakeRect(0,0,50,50));
}

- (float)convertValue:(float)clr
{
	return (clr / 100);
}

- (BOOL)isOpaque
{
	return YES;
}

- (General/IBAction)go:(id)sender
{
	convertedCyan = [self convertValue: [cyan floatValue]];
	convertedMagenta = [self convertValue: [magenta floatValue]];
	convertedYellow = [self convertValue: [yellow floatValue]];
	convertedBlack = [self convertValue: [black floatValue]];

	[self setNeedsDisplay: YES];
}
@end

----

Are you just drawing colors specified by the text fields? And not allowing editing of the General/NSTextView's contents? If so, just make a direct subclass of General/NSView to draw the colors.

I just pasted your code into a simple test project and it's working fine here... I enter values into the text fields, hit go, and the square in the text view changes color. Are you sure the button's action is connected in IB?

Also, drawRect will cover up any text in the text view with your drawing. You probably want to use     drawViewBackgroundInRect:(General/NSRect)aRect instead.

----
Thanks.
I know the button is connected alright.  I can see the  color values working ok via General/NSLog calls. 
The puzzling thing to me is that, through the remaining General/NSLog call in my drawRect: method I can see that the method is only getting called once, when the program starts.  It doesn't get called on each subsequent press of the "go" button.  The go: method is clearly getting called.

You created an interface with 4 text views, an General/NSButton, a subclassed General/NSTextView object, made the connections, used my code unchanged and it worked for you?!  You could change the values, click "go" and the rectangle would draw?  Is the General/NSLog message showing everytime through the drawRect: call?  By the way, I changed the view to a subclass of General/NSView and I'm getting the same situation.

----

Yes to all. I uploaded my test project to [http://www.mimicry.org/General/TestApp.zip]. Maybe some settings in the nib are different.
----
Yes, our nibs are set up differently.  This points to another gap in my understanding.  I don't see where your connections are made in your nib.  I instantiated my General/MyTextView class to make my connections.  How are yours made?

Thanks again.

----

Ah, that's it then. I dragged a General/NSTextView from IB's palette, then under the Custom Class pane in IB's inspector window, set the General/NSTextView to be a General/MyTextView. The General/MyTextView instantiated in your nib is just that - a General/MyTextView instance that never gets inserted into a window.
----
I'm getting in now.  I was looking at my window as being the object handled by my controller, whereas it's actually just the General/NSTextView that is the General/MyTextView object.  Making the connections to that object makes sense and, in fact, works.

Again, thank you for your help.
(another small piece to the puzzle falls into place!)