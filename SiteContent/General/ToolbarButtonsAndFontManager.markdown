I was trying to create B / I / U formatting buttons, rather than use the standard [[NSToolbarShowFontsItemIdentifier]] to pop up a font palette. I know that [[NSFontManager]] changes the actions of its font menu automagically, but it allows only one font menu.

My solution (which I thought was pretty damned smart at the time) was to use the following to simulate the Cmd-B, Cmd-I, and Cmd-U keystrokes of a user when the corresponding toolbar item is clicked:

<code>
[[CGPostKeyboardEvent]]( ([[CGCharCode]])0, ([[CGKeyCode]])55, true );
[[CGPostKeyboardEvent]]( ([[CGCharCode]])'B', ([[CGKeyCode]])11, true );
[[CGPostKeyboardEvent]]( ([[CGCharCode]])'B', ([[CGKeyCode]])11, false );
[[CGPostKeyboardEvent]]( ([[CGCharCode]])0, ([[CGKeyCode]])55, false );
</code>

This worked perfectly ... as long as the user used the standard US keyboard mapping. Unfortunately, many don't. ;-) So now I'm left with a rather annoying problem. I need to figure out how to get the toolbar items to do the right thing (send addTrait or removeTrait appropriately). 

Has anybody done this?

----

I haven't done it, but a quick check of the docs reveals that ''When a responder replies by providing a font to convert in a convertFont: message, the receiver converts the font by adding the trait specified by sender. This trait is determined by sending a tag message to sender and interpreting it as a font trait mask for a convertFont:toHaveTrait: message.''

So just check the standard menu items and set your toolbar items tags appropriately.

----

Tried that. The problem is, the menus are connected to -addFontTrait: ... when I highlight text and click the toolbar, it adds bold, for instance, but if it's already bolded, it doesn't take it away. [[NSFontManager]] actually changes its designated -fontMenu according to the first responder's selection's font traits.

I've even tried doing exactly what the menu is doing in code to no avail:

<code>
	
[[NSFontManager]] '' fontManager = [[[NSFontManager]] sharedFontManager];
[[NSMenu]] '' fontMenu = [fontManager fontMenu:NO];
[[NSMenuItem]] '' menuItem = [fontMenu itemWithTitle:@"Bold"];

[fontManager performSelector:[menuItem action] withObject:menuItem];

</code>

----

I think you need to set the selected font on the font manager to get it to do its thing. [http://developer.apple.com/documentation/Cocoa/Conceptual/[[FontHandling]]/index.html]

''Any object that records fonts that the user can change should tell the font manager what the font of its selection is whenever it becomes the first responder and whenever its selection changes while it�s the first responder. The object does so by sending the shared font manager a setSelectedFont message. It should pass in the first font of the selection, along with a flag indicating whether there�s more than one font.''

----

But this should already be done by my [[NSTextView]], shouldn't it? I can click and highlight text and use the menus or the keyboard shortcuts. Why can I not just send the exact same message as the menu items controlled by [[NSFontManager]], since they already ''automatically'' reflect the  appropriate settings based upon the [[NSTextView]]'s selection? 

----

I've been having this problem too. I came up with this:

<code>
[[[[NSApp]] mainMenu] performKeyEquivalent:
			[[[NSEvent]] keyEventWithType:[[NSKeyDown]]
						    location:[[NSMakePoint]](0,0)
					     modifierFlags:[[NSCommandKeyMask]]
					        timestamp:0
					 windowNumber:0
						    context:[[[NSGraphicsContext]] currentContext]
						characters:@"b"
		         charactersIgnoringModifiers:@"b"
					         isARepeat:NO
					           keyCode:98]];
</code>

Which appears to be layout independent and ''should'' be device independent. I can't be bothered to plug in another keyboard to test though.

----

a bit more general and probably more useful might be

<code>
       [[NSString]] ''character = @"f";
	unsigned int modifiers = 0;
	modifiers |= [[NSCommandKeyMask]];

	// make the event
	[[NSEvent]] '' e = [[[NSEvent]] keyEventWithType: [[NSKeyDown]] 
		location: [[NSMakePoint]](0,0) 
		modifierFlags: modifiers 
		timestamp: 0
		windowNumber: 0
		context: [[[NSGraphicsContext]] currentContext] 
		characters: character
		charactersIgnoringModifiers: [character lowercaseString]
		isARepeat: NO
		keyCode: nil];
	
	// make sure it's good and send it
	if  (e != nil)
	{
		[[[NSApp]] sendEvent: e];
	}
</code>

a few things to point out, the keyCode is 'nil', apparently there is no need to figure this out. also, i'm sending the event to [[NSApp]] so it will go through the complete chain as stated here; http://developer.apple.com/documentation/Cocoa/Conceptual/[[EventOverview]]/[[HandlingKeyEvents]]/chapter_6_section_4.html 

[[MattO]]