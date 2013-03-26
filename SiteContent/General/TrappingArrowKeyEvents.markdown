

i am trying to obtain key events sent to my window and I have been successful. By subclassing [[NSWindow]] etc.

However, within the class I am trying to catch the up and and down arrow keys but it doesn't work. Can somone please look at the code below to see what's wrong? Thanks a lot.

This works
<code>
- (void)keyDown: ([[NSEvent]] '') event
{
	[[NSString]] ''input = [event characters];
	if([input isEqual: @"\t"])
	{
		[[NSLog]](@"Tab pressed");
		return;
	}
}
</code>

But this doesn't and I get a warning. I understand that [[NSUpArrowFunctionKey]] is an integer, but how do I actually compare it.
[[RealControl]].m:27: warning: comparison between pointer and integer
<code>
- (void)keyDown: ([[NSEvent]] '') event
{
	if([event characters] == [[NSUpArrowFunctionKey]])
	{
		[[NSLog]](@"Up Arrow pressed");
		return;
	}
}
</code>
Neither does this work, and I get no warnings or errors
<code>�
- (void)keyDown: ([[NSEvent]] '') event
{
	if([event keyCode] == [[NSUpArrowFunctionKey]])
	{
		[[NSLog]](@"Up arrow pressed");
		return;
	}
}
</code>

Can someone please tell me what's wrong?
Thanks again.

Shaun.
 ----

Try [[ArrowKeyForKeyEquivalent]], and then do a little digging, since that page deals only with left and right. The others should be close at hand.

----

Try <code>if ([[event characters] characterAtIndex:0] == [[NSUpArrowFunctionKey]])</code>

''I see this a lot, even an Apple guy posted this, but it is broken! It will throw an exception if the event contain no characters, and some key events do!''

----

This should work too.
<code>
- (void)keyDown:([[NSEvent]] '')event
{
	[[NSString]] ''input = [event characters];
	
	if([input isEqual:[[[NSString]] stringWithFormat:@"%C", [[NSUpArrowFunctionKey]]]])
	{
		[[NSLog]](@"Up Arrow pressed");
		return;
	}
}
</code>
''What if two keys are pressed at once?''

Then you should figure out what logically makes sense in your situation. :-)