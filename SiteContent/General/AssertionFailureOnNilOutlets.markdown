

I'm trying to run a sheet in an app I'm creating. I run

    
General/[NSApp beginSheet:resultsPanel modalForWindow:theWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];


but it says that

    
2005-12-16 22:05:46.963 General/TicketEval[27118] *** Assertion failure in -General/[NSApplication _commonBeginModalSessionForWindow:relativeToWindow:modalDelegate:didEndSelector:contextInfo:], General/AppKit.subproj/General/NSApplication.m:2763
2005-12-16 22:05:47.071 General/TicketEval[27118] Modal session requires modal window


Can anyone help me fix this?

----
Well, this isn't too helpful...because it looks as if nothing is wrong. Of course, that's your problem. My first guess would be that     theWindow is not being properly initialized, or is still     nil. Check your outlets. --General/JediKnil
----

Jeez, I'm stupid. Didn't check my outlets closely enough. I was using resultPanel in IB and resultsPanel in my code.