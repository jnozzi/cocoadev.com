

I've been playing around with the example code of General/TextEdit....

...and I'm dying....

Basically, I just want to modify the starting locations of the tabs in the General/NSRuler of the General/NSTextView and I'm having a hell of a time trying to access the Markers array of the General/NSRuler.

Here's what I've got so far...

    
//This is in the Document setup
// get the General/NSTextView
General/NSTextView *textView = [self firstTextView];

//change the font
General/NSFont *theFont = General/[NSFont fontWithName:@"Courier" size:12.0];
[textView setFont:theFont];

// get the General/NSScrollView of the General/NSTextView to get to the General/NSRuler
// why can't I get the General/NSRuler from the General/NSTextView??????
General/NSScrollView *sv = [textView superview];

// get the General/NSRuler from the General/NSScrollView 
General/NSRulerView *rv = General/[NSScrollView rulerViewClass];

// now when I look in the debugger, rv seems to be a proper General/NSRulerView

// try to get the array of markers
// THIS IS WHAT DOESN'T WORK
General/NSArray *ma = [rv markers];


I get this in the run log "+General/[NSRulerView markers]: selector not recognized"
The documentation for General/NSRulerView says that there's a markers array, but I can't seem to get to it....

How do I access the markers array of my General/NSRuler?

HELP!

Thanks!
	
----

You're not getting an General/NSRulerView instance. Your first clue to the error is the "+" in front of General/[NSRulerView markers]. This shows you it's trying to send -markers to the General/NSRulerView CLASS, not an instance.

Looking earlier in your code you're asking the scrollview for the *class*, not the instance itself. Check out the General/NSScrollView documentation and you'll see that -rulerViewClass hands back a *class*. You want -horizontalRulerView and -verticalRulerView.