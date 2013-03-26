I have an [[NSSearchField]] in an [[NSToolbar]] and a large [[WebView]] spanning the content of the parent window. I want the [[NSSearchField]] to behave like the search field in the Dictionary app included with Tiger, which passes up/down arrow and pg up/down key presses to the [[WebView]] to let the user scroll without leaving the search field.

I've tried subclassing [[NSSearchFieldCell]] and overriding its keyDown:, but calling [searchField setCell:newCell] breaks the [[NSSearchField]] so that only the magnifying glass is displayed.

I've also tried subclassing just [[NSSearchField]], but its keyDown: never gets called.

Am I going about this the wrong way? I'd be grateful for any help.

-[[JustinAnderson]]

----

Read up on the [[FieldEditor]], and add this to your search field's delegate:

<code>
- (BOOL)control:([[NSControl]] '')control textView:([[NSTextView]] '')textView doCommandBySelector:(SEL) commandSelector
{
     BOOL retval = NO;
     if (commandSelector == @selector(moveDown:)) {
         retval = YES;
         // manipulate your web view
         [theWebView scrollLineDown:nil];
     } else if (commandSelector == @selector(moveUp:)) {
         retval = YES;
         // manipulate your web view
         [theWebView scrollLineUp:nil];
     }
     return retval;
}
</code>

The [[FieldEditor]] is the first responder, and it receives the original keyDown: message.  However, it has plenty of delegate methods, so there is no reason to subclass to change this behavior.

----

Thank you very much! I edited the above code to include the commands that should be passed to the [[WebView]].
- [[JustinAnderson]]