

I'm having trouble with General/WebView's createWebViewWithRequest:. I've implemented all needed code in my project, as well as set the delegate for createWebViewWithRequest in General/WindowControllerDidLoadNib, but it won't yield new windows when asked to (General/JavaScript requests, "Open in New Window" requests) in the compiled application. I've even attached an General/NSLog to it - General/NSLog reports nothing as if the new window implementation were working perfectly.

What's the problem?

 The code is copied and pasted directly from the Developer Documentation.