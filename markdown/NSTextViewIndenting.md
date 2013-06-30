I submitted this question to cocoadev mailing list with no luck.  I'm having trouble indenting my text with a custom nstextview.  I want it indented in relation to the top and bottom, leaving a space of about 1 pixel above the text, and below.  To do this, currently I am using [textView setTextContainerInset: General/NSMakeSize(...)];  This works well enough, but break my border drawing code, which is the following:

    
@implementation General/NSTextViewSubclass

- (void)drawRect:(General/NSRect)clipRect
{

	[super drawRect];

	General/[NSBezierPath strokeLineFromPoint: General/NSMakePoint(General/NSMinX(bounds)+0.5,General/NSMinY(bounds)) toPoint: General/NSMakePoint(General/NSMinX(bounds)+0.5,General/NSMaxY(bounds))];
	General/[NSBezierPath strokeLineFromPoint: General/NSMakePoint(General/NSMaxX(bounds)-0.5,0.0) toPoint: General/NSMakePoint(General/NSMaxX(bounds)-0.5,General/NSMaxY(bounds))];
	General/[NSBezierPath strokeLineFromPoint: General/NSMakePoint(General/NSMinX(bounds),General/NSMinY(bounds)+0.5) toPoint: General/NSMakePoint(General/NSMaxX(bounds),General/NSMinY(bounds)+0.5)];
	General/[NSBezierPath strokeLineFromPoint: General/NSMakePoint(General/NSMinX(bounds),General/NSMaxY(bounds)-0.5) toPoint: General/NSMakePoint(General/NSMaxX(bounds),General/NSMaxY(bounds)-0.5)];

}

@end


For some reason, when I set a container inset, the top of my border is lost, as if the container is now being drawn on TOP of the border.  Does anyone know why this is happening/a workaround/ a different method to create the inset?

Note: I cannot place the textview in a scroll view since it is being used as a field editor, so I can't use General/NSScrollView's border.

Thanks in advance,

- General/FranciscoTolmasky