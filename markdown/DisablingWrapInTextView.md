

Is there an easy way to prevent an General/NSTextView from wrapping it's contents... so it shows the horizontal scrollbar?

----
You could try setting its springs in IB to stretch horizontally, but keep the containing scroll view on a fixed-width.
----

Thanks, but I need to have the scroll view scale with the window. :)

----
See file:///Developer/Examples/General/AppKit/General/TextSizingExample
----

----

Here is a simple way to disable wrapping in an existing General/NSTextView:

    
const float General/LargeNumberForText = 1.0e7;

General/NSScrollView *scrollView = [textView enclosingScrollView];
[scrollView setHasVerticalScroller:YES];
[scrollView setHasHorizontalScroller:YES];
[scrollView setAutoresizingMask:(General/NSViewWidthSizable | General/NSViewHeightSizable)];

General/NSTextContainer *textContainer = [textView textContainer];
[textContainer setContainerSize:General/NSMakeSize(General/LargeNumberForText, General/LargeNumberForText)];
[textContainer setWidthTracksTextView:NO];
[textContainer setHeightTracksTextView:NO];

[textView setMaxSize:General/NSMakeSize(General/LargeNumberForText, General/LargeNumberForText)];
[textView setHorizontallyResizable:YES];
[textView setVerticallyResizable:YES];
[textView setAutoresizingMask:General/NSViewNotSizable];
