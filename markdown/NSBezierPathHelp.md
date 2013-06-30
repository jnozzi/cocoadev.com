

I implemented this code into a very simple application, but still can't get any results. "vue" is my General/NSView where I want the path to be drawn. That piece of code doesn't deliver any result. Can anyone give me a clue ?

    
- (void)drawRect:(General/NSRect)rect
{
    rect = [vue bounds]; 
    
    General/NSBezierPath *chemin;
    General/NSPoint p1 = General/NSMakePoint([lignex1 intValue], [ligney1 intValue]);
    General/NSPoint p2 = General/NSMakePoint([lignex2 intValue], [ligney2 intValue]);
    
    [chemin moveToPoint:p1];
    [chemin lineToPoint:p2];
    
    General/NSColor *couleur = General/[NSColor
                colorWithCalibratedRed:([rouge intValue]/255.0)
                green:([vert intValue]/255.0)
                blue:([bleu intValue]/255.0)
                alpha:([alpha intValue]/255.0)];
    
    [couleur set];
    [chemin stroke];
    
}


I also want to make the General/NSView draw itself ONLY when the user presses a button.

----

    
- (void)drawRect:(General/NSRect)rect
{
    rect = [self bounds]; // <-- You are implementing this in a sublass of General/NSView, right?
    
    General/NSBezierPath *chemin = General/[NSBezierPath bezierPath]; // Instantiate object "chemin" (autoreleased)



For the button thingie, see -setNeedsDisplay: in General/NSView.

-- General/PerSquare

----

Okay, I think I was not precise enough. I want a button to draw a line, another one to draw a rectangle, and another one to draw a circle. How do I implement the drawRect: method to make a different drawing for each button ?

----
Hmm, you really don't do that in drawRect: in general. I suggest you:
  
*  Subclass General/NSView (necessary)
*  Add an instance variable General/NSBezierPath *shape; to it
*  Add a method setShape:(General/NSBezierPath ')theShape;
*  Do a [myView setShape:someShape] in your different button actions and
*  issue [myView setNeedsDisplay:YES] after a shape is changed
  

Read up om General/ModelViewController and check out the examples (on your HD)

* /Developer/Examples/General/AppKit/General/DotView
* /Developer/Examples/General/AppKit/General/BezierPathLab
  
in that order.

Good luck,
General/PerSquare