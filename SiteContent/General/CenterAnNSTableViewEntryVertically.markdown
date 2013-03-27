Basically, I have an General/NSTableView with a large rowheight.  When I add a row of text into it, it gets drawn from the top... I'd like it to be centered vertically.  What's the quickest and easiest way to do this?  I'd prefer not having to subclass General/NSTextFieldCell.

Thanks!

----

I'm afraid you need to subclass General/NSTextFieldCell, but it doesn't look very complicated. See this on how to implement it: http://cocoa.mamasam.com/MACOSXDEV/2003/06/2/67000.php

-- General/RyanBates