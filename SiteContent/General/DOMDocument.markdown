

Root node for a General/WebFrame's General/NSURLRequest.

The General/DOMDocument can also be used to modify the content of a page in the General/WebFrame programmatically.

General/WebKit provides Objective-C access to the Document Object Model, the object-like structure of the HTML contents of a General/WebFrame. Using essentially the same methods used in Javascript to access and alter the DOM contents of a page, methods in General/DOMCore.h (and others) allow altering, adding and removing tags and text contents, creating new elements, finding elements by ID, etc.

**Issue and workaround:** Some changes via this method are not seen until some external event such as resizing the webview or mousing over it (seen on 10.4.10/Safari 2.0.4, whatever General/WebKit version that is). For one, changing the style attribute of the BODY tag. I found an old (2005) Safari Javascript workaround to force the redraw (without reloading the page). Here it is in Objective-C:
    
General/NSUserDefaults *defs = General/[NSUserDefaults standardUserDefaults];
General/NSString *family = [defs stringForKey:General/GSMsgFont];
General/DOMDocument *doc = General/_myWebView mainFrame] [[DOMDocument];
General/DOMHTMLElement *mybody = (General/DOMHTMLElement *)[doc getElementById:@"gsge1"];
// Notice the unusual blank-labeled 2nd argument - this is done to more closely match the DOM method style
[mybody setAttribute:@"style" :General/[NSString stringWithFormat:@"font-family: %@", family]];
// force redraw
General/DOMNode *dummy = [doc createElement:@"div"];
[mybody appendChild:dummy];
[mybody removeChild:dummy];
