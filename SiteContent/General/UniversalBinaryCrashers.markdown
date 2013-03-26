I have recently compiled my app for Intel Macs, and brought over all the frameworks and whatnot.  Finder info states that the app is Universal and it launches and runs on my brother's Macbook Pro fine (My development machine is my Powerbook).  But a certain action causes it to crash (and here's where it gets weird).

<code>
Exception:  EXC_BAD_ACCESS (0x0001)
Codes:      KERN_PROTECTION_FAILURE (0x0002) at 0x00000012

Thread 0 Crashed:
0   libobjc.A.dylib               	0x908e54b8 objc_msgSend + 8
1   com.apple.[[AppKit]]              	0x9221d20c -[[[NSTableView]] drawRect:] + 1323
2   com.limbiclogic.[[TrapperKeeper]] 	0x0000fa6c -[[[ResultsTable]] drawRect:] + 56
3   com.apple.[[AppKit]]              	0x921493b1 -[[[NSView]] _drawRect:clip:] + 3228
4   com.apple.[[AppKit]]              	0x9214840b -[[[NSView]] _recursiveDisplayAllDirtyWithLockFocus:visRect:] + 614
5   com.apple.[[AppKit]]              	0x92147473 -[[[NSView]] _recursiveDisplayRectIfNeededIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:topView:] + 217
6   com.apple.[[AppKit]]              	0x92148041 -[[[NSView]] _recursiveDisplayRectIfNeededIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:topView:] + 3239
7   com.apple.[[AppKit]]              	0x92148041 -[[[NSView]] _recursiveDisplayRectIfNeededIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:topView:] + 3239
8   com.apple.[[AppKit]]              	0x92148041 -[[[NSView]] _recursiveDisplayRectIfNeededIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:topView:] + 3239
9   com.apple.[[AppKit]]              	0x92148041 -[[[NSView]] _recursiveDisplayRectIfNeededIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:topView:] + 3239
10  com.apple.[[AppKit]]              	0x922268a9 -[[[NSNextStepFrame]] _recursiveDisplayRectIfNeededIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:topView:] + 601
11  com.apple.[[AppKit]]              	0x92146362 -[[[NSView]] _displayRectIgnoringOpacity:isVisibleRect:rectIsVisibleRectForView:] + 523
12  com.apple.[[AppKit]]              	0x92145c8e -[[[NSView]] displayIfNeeded] + 439
13  com.apple.[[AppKit]]              	0x92145a32 -[[[NSWindow]] displayIfNeeded] + 168
14  com.apple.[[AppKit]]              	0x920eb378 -[[[NSWindow]] _reallyDoOrderWindow:relativeTo:findKey:forCounter:force:isModal:] + 1225
15  com.apple.[[AppKit]]              	0x920eae5e -[[[NSWindow]] orderWindow:relativeTo:] + 104
16  com.apple.[[AppKit]]              	0x921c35f8 -[[[NSWindow]] orderFront:] + 49
</code>

Crash report form the intel mac, using [[HDCrashReporter]].  Note that the last call from my program is [[[ResultsTable]] drawRect:].  Wanna see the code?

<code>
- (void)drawRect:([[NSRect]])rect
{
	[super drawRect:rect];
}
</code>

Yep, I swear.  Anyway, I image keeping this page as a repository of common crashes, since after poring over the docs and the help pages here I'm starting to get the impression I'm the only person having trouble converting to UB.  Any ideas on this crasher?  Man I'd love to have this fixed because universalizing is the last thing on my list before release.

----
See [[DebuggingTechniques]], particularly [[NSZombieEnabled]].

----
Yeah, I kept studying the log and decided to do a search here for libobjc.A.dylib and came up with a bunch of interestingly similar hits.  However, they differ drastically in the fact that this is a program which works just fine on a [[PowerPC]] and not on an Intel.  So this is some architectural difference in how nil is handled, maybe?  Though I don't see how in the above code super or rect can be nil.  I'd be happy to answer any questions; I've been at this and this alone all day and I don't know any more about this problem than I did before, though I have learned a bit more about the debugger (a tool I do use alot on my own machine, though never these crash logs in .txt like this).

Unfortunately I don't have access to the intel so I can't just run it in the debugger and see where it actually is crashing.  Though the above log makes it look like it's [[NSTableView]] that is crashing, not any of my code.  Which I do have a hard time believing but how would you read it?  Another question: what does this mean: [[[ResultsTable]] drawRect:] + 56 ?  It doesn't match up to the line numbers in my code.

----

This probably won't help you much, but out of curiosity: why are you bothering to implement drawRect: at all if all it's doing is calling super (which is what would happen if you didn't have the method there)? -- [[RobRix]]

----

Hehe.  The truth is I usually have to subclass about 3 different classes and 15 methods before I find out that all I needed was to override -objectValue.  So, that method once upon a time has some content in it but has since been demoted.  In my experience as soon as I delete something I find I need it, so I'm kinda leaving it there to protect myself.  I guess you could chalk up my superstitious behavior to the fact that I'm new at this and it's all still magic to me.

----

Also, I narrowed down the problem to [[NSBezierPath]].  My tableView subclass does some custom highlighting where it draws an [[NSBezierPath]], and to do this I am using a category which includes this method:

<code>
- (void) appendBezierPathWithRoundedRectangle: ([[NSRect]]) aRect
                                   withRadius: (float) radius
{
	//[self appendBezierPathWithOvalInRect:aRect];
	//return;

	[[NSPoint]] topMid = [[NSMakePoint]]([[NSMidX]](aRect), [[NSMaxY]](aRect));
	[[NSPoint]] topLeft = [[NSMakePoint]]([[NSMinX]](aRect), [[NSMaxY]](aRect));
	[[NSPoint]] topRight = [[NSMakePoint]]([[NSMaxX]](aRect), [[NSMaxY]](aRect));
	[[NSPoint]] bottomRight = [[NSMakePoint]]([[NSMaxX]](aRect), [[NSMinY]](aRect));
	
	[self moveToPoint: topMid];
	[self appendBezierPathWithArcFromPoint: topLeft
						toPoint: aRect.origin
						radius: radius];
	[self appendBezierPathWithArcFromPoint: aRect.origin
						toPoint: bottomRight
						radius: radius];
	[self appendBezierPathWithArcFromPoint: bottomRight
						toPoint: topRight
						radius: radius];
	[self appendBezierPathWithArcFromPoint: topRight
						toPoint: topLeft
						radius: radius];
	[self closePath];
}
</code>

The code is called from

<code>
	[[NSBezierPath]] ''path = [[[NSBezierPath]] bezierPath];
		[path appendBezierPathWithRoundedRectangle:[self bounds] withRadius:3.];
	[path fill];
</code>

If I turn off this method (by uncommenting the first part) the program runs fine on the Intel.  I don't see where this is going wrong.

----
Got it working!  To me VERY oddly, the calling code had to be changed to:

<code>
	[[NSBezierPath]] ''path = [[[NSBezierPath]] bezierPath];
		[path appendBezierPathWithRoundedRectangle:[[NSInsetRect]]([self bounds],0,0) withRadius:3.];
	[path fill];
</code>

almost as if calling [self bounds] wasn't being held onto long enough to do the drawing.  A phony [[NSInsetRect]] has saved the day!  Why this would differ from PPC to Intel...

----

What the value of [self bounds] in that function? Intel and PPC differ in how they treat some floating-point values, I think.