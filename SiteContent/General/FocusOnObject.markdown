I was just wondering how to change the focus (focus ring and cursor) to an object in the nib. Can anyone enlighten me?

----

You mean programatically? If so, thusly:
<code>
[window makeFirstResponder:myObject]
</code>

If you want the window to open with a particular object as first responder, connect the window's initialFirstResponder outlet to that object in the nib.

A [[NSTabViewItem]] instance also has an initialFirstResponder outlet to specify which object should have focus when this item is chosen in the [[NSTabView]].

----
----

Once my program receives a specific event, I'd like a window to appear and set focus on an [[NSTextField]]. Here's the code I'm trying now:

<code>[self orderFrontRegardless];
[self makeKeyWindow];
[self makeFirstResponder:textField];</code>

However, %%BEGINCODESTYLE%%textField%%ENDCODESTYLE%% is never given focus. Am I doing something wrong here?

-- [[RyanGovostes]]

----

have you tried <code>[self makeKeyAndOrderFront:nil]</code>?

----

This does not seem to work either. If the window is key, does it even receive keyDown events? If so, I could just ditch the [[NSTextField]], but when I write this in my Window subclass, nothing happens when I hit a key:

<code>- (void)keyDown:([[NSEvent]] '')theEvent {
    [[NSLog]](@"[[KeyDown]] event!\n");
}</code>

-- [[RyanGovostes]]

----

Try removing the text field and overriding <code>-(BOOL)acceptsFirstResponder</code> in your window class, returning <code>YES</code>, then the <code>keyDown</code> event should fire. Works for me.

----

Yeah, the <code>keyDown</code> event fires, but if the cursor is in a different window, it still doesn't receive the event.

see (perhaps relevant) discussion at [[SimulateTyping]]