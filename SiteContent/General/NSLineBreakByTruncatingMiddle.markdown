

Check out this nice example:
http://developer.apple.com/documentation/Cocoa/Conceptual/Rulers/Tasks/General/TruncatingStrings.html

----

See General/NSParagraphStyle.h

    General/NSLineBreakByTruncatingMiddle	/* Truncate middle of line:  "ab...yz" ??? Doesn't work yet */

For a work-around, see General/BetterTruncatingStringsInTableView.

----

----
Thanks! This works awesome!

----

Here is a sample project showing General/NSLineBreakByTruncating. This example is based on the Apple code at the address above.

http://www.nancesoftware.com/development/sample_code/linebreakbytruncating/

I added the option to truncate by using General/NSLineBreakByTruncatingHead, General/NSLineBreakByTruncatingMiddle, or General/NSLineBreakByTruncatingTail.

General/JacobHazelgrove