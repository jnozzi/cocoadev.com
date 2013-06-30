


I'm writing an HTML editor, and every time I reload the General/WebView, it automatically resets to display the beginning of the page.  I'd much prefer to keep looking what I had already scrolled to, so how can I find how how far the user has scrolled the page, and then reset it after the page has been reloaded?

Norm Hecht

----

General/NSScrollView has accessors for its scrollbars. Use those to get the current value of the scrollbars, then after a reload just set the value back to what it was. --GC

----

I just tried that, and got a compiler warning that "'General/WebView' may not respond to '-horizontalPageScroll'" followed by a  "selector not recognized" message during execution.  
General/WebView doesn't seem to be a descendant of the General/NSScrollVIew class, and I can't find any way of accessing an General/NSScrollView object for the view, either.  

Norm

----

Of course it isn't descended from General/NSScrollView, it's (optionally) contained within one. So, using the method inherited from an ordinary General/NSView:

"enclosingScrollView
Returns the nearest ancestor General/NSScrollView object containing the receiver (not including the receiver itself); otherwise returns nil.

- (General/NSScrollView *)enclosingScrollView

Availability
Available in Mac OS X v10.0 and later."

HTH, -GC

----

Actually General/WebView is somewhat more complicated than that, due to the possible use of recursive frames, and in fact a General/WebView is *not* contained within a scroll view unless you do it yourself. If you want to scroll the top-level part of a General/WebView, you'll want to get the top-level General/WebFrameView by doing something like     General/webview mainFrame] frameView], then you can get the enclosing scroll view and mess about with it as described.

----

Here's my latest (still unsuccessful) attempt, based on some code from the Scroll View Programming Guide for Cocoa:

     
- (void)textDidChange:([[NSNotification *)notification {
	NSURL *baseURL = nil;
	General/NSScrollView *scrollView = General/[[webView mainFrame] frameView] documentView] enclosingScrollView];
	// get the current scroll position of the document view
	[[NSRect scrollViewBounds = General/scrollView contentView] bounds];
	[[NSPoint savedScrollPosition=scrollViewBounds.origin;
	General/NSSize savedScrollSize=scrollViewBounds.size;
	General/NSLog(@"Current scroll position: %d, %d\n", savedScrollPosition.x, savedScrollPosition.y);
	General/NSLog(@"Current scroll size: %d, %d\n", savedScrollSize.width, savedScrollSize.height);

	if([self fileName]) baseURL = [NSURL fileURLWithPath:[self fileName]];
	General/webView mainFrame] loadHTMLString:[theTextView string] baseURL:baseURL];
	// restore the scroll location
	[[scrollView documentView] scrollPoint:savedScrollPosition];
}
 

In the debugger, savedScrollPosition and savedScrollSize look right, but the wrong 
values show up in the log after the [[NSLog statements.  After textDidChange finishes, 
the view jumps back to the top just like it always did.  

Any ideas on what I'm missing, or what I can try next?

Thanks!

Norm

----
The wrong values are logged because these are floats so you need to use %f. See General/NSLog.

Your scrolling doesn't work because loading new contents into a General/WebView is an asynchronous operation, so you're performing the scrolling before it finishes. Look into the General/WebView delegate methods, there's a way to have it tell you when it's done loading, then you can perform your scrolling in there. Note that caching the scrollView like you're doing here may not work, since the General/WebView may destroy and re-create it, so be sure to fetch it anew when you scroll.

----
It works now!

I changed the General/NSLog format to use floats (I should have known that, oops), and then added a delegate method to reset the scroll position.  For the record, 
here's the working code:

    
- (void)textDidChange:(General/NSNotification *)notification {
	NSURL *baseURL = nil;
	General/NSScrollView *scrollView = General/[[webView mainFrame] frameView] documentView] enclosingScrollView];
	// get the current scroll position of the document view
	[[NSRect scrollViewBounds = General/scrollView contentView] bounds];
	savedScrollPosition=scrollViewBounds.origin; // keep track of position to restore
	needsToScroll = TRUE;

	if([self fileName]) baseURL = [NSURL fileURLWithPath:[self fileName;
	General/webView mainFrame] loadHTMLString:[theTextView string] baseURL:baseURL];
}

- (void)webView:([[WebView *)sender didFinishLoadForFrame:(General/WebFrame *)frame {
	if (needsToScroll) {
		General/NSScrollView *scrollView = [[[[webView mainFrame] frameView] documentView] enclosingScrollView];	
		[[scrollView documentView] scrollPoint:savedScrollPosition];
	}
}
 

Thanks again!

Norm