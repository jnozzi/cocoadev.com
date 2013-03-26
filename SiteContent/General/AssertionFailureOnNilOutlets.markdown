

I'm trying to run a sheet in an app I'm creating. I run

<code>
[[[NSApp]] beginSheet:resultsPanel modalForWindow:theWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];
</code>

but it says that

<code>
2005-12-16 22:05:46.963 [[TicketEval]][27118] ''''' Assertion failure in -[[[NSApplication]] _commonBeginModalSessionForWindow:relativeToWindow:modalDelegate:didEndSelector:contextInfo:], [[AppKit]].subproj/[[NSApplication]].m:2763
2005-12-16 22:05:47.071 [[TicketEval]][27118] Modal session requires modal window
</code>

Can anyone help me fix this?

----
Well, this isn't too helpful...because it looks as if nothing is wrong. Of course, that's your problem. My first guess would be that <code>theWindow</code> is not being properly initialized, or is still <code>nil</code>. Check your outlets. --[[JediKnil]]
----

Jeez, I'm stupid. Didn't check my outlets closely enough. I was using resultPanel in IB and resultsPanel in my code.