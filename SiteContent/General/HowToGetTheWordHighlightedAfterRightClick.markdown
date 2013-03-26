
When you right-click on a word in [[NSTextView]] the word is immediately highlighted and then contextual menu appears. I need to get the highlighted word before menu appears, so depending on this word I can insert a menu item into contextual menu. There should be some way to do it, but I can't find any. Any help?

----

Override <code>menuForEvent:</code>?

----
If I override  <code>menuForEvent:</code> and return my menu then the word isn't higlighted. It happens somewhere in [[NSTextView]]'s own <code>menuForEvent:</code>. Is there any way to get a word under the cursor?

----

If it happens in [[NSTextView]]'s own <code>menuForEvent:</code>, then wouldn't everything work properly if you just call <code>[super menuForEvent:theEvent]</code> before running your own code?

----

Yes, but I don't see how can I read the word that was highlighted after control-click. When I call <code>[super menuForEvent:theEvent]</code> then on control-click the word is highlighted and menu appears. What I need is to get the word into a variable just after it was highlighted, but before menu appears.

----

So this doesn't work?

<code>
- ([[NSMenu]] '')menuForEvent:([[NSEvent]] '')event {
   [super menuForEvent:event];
   word = [[self string] substringWithRange:[self selectedRange]];
   ... do stuff here ...
   return menu;
}
</code>

----

Thank you. It works. But when I just called <code>[super menuForEvent:]</code> without returning any menu, default menu still popped up, so I thought this way it won't work. Excuse me. It was stupid.

''Shouldn't the menu be caught from super? <code>[[NSMenu]] '' menu = [super menuForEvent:event];</code> ...? ''

That would depend on whether you want to simply add to the default menu, or whether you want a completely custom menu.