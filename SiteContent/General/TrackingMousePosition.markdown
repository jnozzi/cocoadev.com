Tracking Mouse Position snippet:

<code>
TRACKING MOUSE POSITION

	//declare rect
	[[NSRect]] myRect = [[NSMakeRect]](10,10,30,90);
	[[NSPoint]] loc = [[self window] mouseLocationOutsideOfEventStream];
	[[NSLog]](@"%s",[[[NSStringFromPoint]](loc) cString]);
	//	[[NSLog]](@"rect is: %s",[[[NSStringFromRect]](parentFrame) cString]);

	if ([self mouse:loc inRect:myRect]){
		[[NSLog]](@"got it!");
		[testWindow makeKeyAndOrderFront:nil];
		[testWindow setAlphaValue:.5];
		[self animateVortex];
	}



 </code>

[[EcumeDesJours]]

keywords: tracking, hotspot, hotzone, mouseposition

----

Also <code>[[[NSEvent]] mouseLocation]</code>

''
+ ([[NSPoint]])mouseLocation

Exports the current mouse position, in screen coordinates. Similar to [[NSWindow]]�s mouseLocationOutsideOfEventStream, this method returns the location regardless of the current event or pending events. The difference between these methods is that mouseLocationOutsideOfEventStream returns a point in the receiving window�s coordinates and mouseLocation returns the same information in screen coordinates.
''