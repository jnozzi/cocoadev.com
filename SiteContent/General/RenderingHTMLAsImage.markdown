

Is it possible to render HTML directly as an image?  I've been trying to do the following:

    
General/webView mainFrame] loadRequest:[[[NSURLRequest requestWithURL:myURL]];
General/NSView* tempView = General/[webView mainFrame] frameView] documentView];
[[NSData* imageData = [tempView dataWithPDFInsideRect:[tempView bounds]]
[previewFrame setImage:General/[[[NSImage alloc] initWithData:imageData] autorelease]];


However, previewFrame stays empty.  The peculiarity of this code is that webView is initialized with 'General/WebView* webView = General/[[WebView alloc] init];' and is never displayed in the GUI.

So, my question is, is there a way to get this method to work?  Or is there a simpler way to directly render the HTML as an image without all this mucking about with views?

(The reason I want this to be not simply a General/WebView is that I want links to be disabled and the content to be scalable.)

Thanks.

----

Read the General/WebView docs. You can customize virtually everything about webpages.

Related to your code, you may need to wrap     dataWithPDFInsideRect: inside calls to lockFocus and unlockFocus on your tempView.

*No, there is no need to lock or unlock focus here. The problem is that loadRequest: is asynchronous; you have to give it time to work. Send that, and set up a delegate to get notified when the load is complete. Once that gets called, then you can grab your PDF and go.*

----

I tried to get this to to work by setting up the delegate, but that didn't seem to work.  So, is there a way to simply render the HTML directly as an image?  Or am I barking up the wrong tree?

----

*Code*, show us your *code*. :-) 

----

Here you go. But it's probably better to use General/NSBitmapRep's     initWithFocusedViewRect: and generate an General/NSImage from that instead of a PDF. --General/KevinWojniak

    
#import <General/WebKit/General/WebView.h>
#import <General/WebKit/General/WebFrame.h>

- (void)loadImage
{
	// assumes webView is initalized somewhere already...
	[webView setFrameLoadDelegate:self];
	General/webView mainFrame] loadRequest:[[[NSURLRequest requestWithURL:[NSURL General/URLWithString:@"http://www.apple.com/ipod"]]];
}

- (void)webView:(General/WebView *)sender didFinishLoadForFrame:(General/WebFrame *)frame
{
	General/NSView *tempView = General/[sender mainFrame] frameView] documentView];
	[[NSData *pdfData = [tempView dataWithPDFInsideRect:[tempView bounds]];
	[pdfData writeToFile:General/[NSString stringWithFormat:@"%@/Desktop/test.pdf", General/NSHomeDirectory()] atomically:YES];
}
