I don't understand why Objective-C cannot permit for() loops in the drawRect: method of a General/NSView...

I can't do what I want to do without a for() loop. Here's a description of what I have done yet :

I have a General/NSMutableArray with some General/NSNumber objects in it.
These objects determine the width of rectangles that are to be drawn in my General/NSView.
I want to implement a loop, in which General/NSBezierPath objects are drawn depending on the value of the General/NSNumber objects in my array...

I tried to implement a for() in the drawRect method, but the loop never executes...

Last thing that may be important. My General/NSView is actually a subview of a General/NSScrollView...

-- Trax

----

I think you could just create a class method or something that would be able to do it. Search for: "regular polygon". You'll find some code in the topic that uses a for () loop and then returns a bezier path to the drawRect: method. 
I hope this is what your looking for. 

-- General/JohnDevor

----

Curious: why are you subclassing General/NSScrollView? You don't need to subclass that to get scrolling behaviour, only to override the scrolling behaviour General/NSScrollView provides (e.g. the scroll bars, et cetera). -- General/RobRix

----

My General/NSView is a subview of General/NSScrollView, but I didn't programmatically set the General/NSView to be the documentView of my General/NSScrollView... 

Could someone explain why a for loop will not iterate inside a method implementation of drawRect:. I do this all the time and I'm puzzled that this is even an issue. I think the problem with subclassing General/NSScrollView is that an General/NSScrollView doesn't draw anything (only subviews of General/NSScrollView draw things - General/NSScrollers and the document view). If you try to draw thing in the drawRect method of an General/NSScrollView I think the clip view (General/NSScrollView's contentView) will hide any drawing that is going on. You should really be subclassing General/NSView to do any drawing and setting the documentView of the scroll view to your custom General/NSView (General/MyView). 

    
    id scrollView=General/[[NSScrollView alloc] initWithFrame:scrollViewframe];
    id myView=General/[[MyView alloc] initWithFrame:myViewFrame];
    [scrollView setDocumentView:myView];


----

The trick for regular polygons is good, but for what I want to do, I don't think it could be efficient, since I imperatively need more than one General/NSBezierPath, because I want my General/NSView to draw multiple rectangles...

I found something else strange. With multiple General/NSLogs scattered around my code, I found that whenever I try to get [myArray count], it returns zero, even though there ARE objects in it... That's why my for() doesn't do anything.

Here's a part of my code...
    
- (void)drawRect:(General/NSRect)rect
{
    General/[[NSGraphicsContext currentContext] setShouldAntialias:NO];
    General/[NSBezierPath setDefaultLineWidth:1.0];
    
    General/NSRect lim = [self bounds];
    int h = lim.size.height-8;
    int i, acc = 0;
    General/NSLog(@"Count is : %i",[lis count]); // <-- Returns zero !!!
    
    for (i=0; i<[lis count]; i++) {
    General/NSLog(@"Count is : %i",i);
        General/[[NSBezierPath bezierPathWithRect:General/NSMakeRect(acc,5,[[lis objectAtIndex:i] intValue],h)] stroke];
        acc += [[lis objectAtIndex:i] intValue] + 4;
    }
}



The problem had to do with an incorrectly linked outlet and several incorrectly linked actions. Minor mistakes that are easily overlooked.