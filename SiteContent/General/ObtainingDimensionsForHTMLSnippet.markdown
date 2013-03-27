

Hi!

I'm working on an application that, among other things, involves the layout of items in HTML segments.  I'm going to be using an algorithm that searches through the set of possible layouts for an optimum.

In order to do that though, I first need to calculate the space each HTML segment requires, and preferably for several different aspect ratios.

Does anyone know of a way to take a chunk of HTML (possibly containing images, and maybe even flash content, and probably with some accompanying CSS) and, for example, a  desired width, and return the minimum dimensions (bounds rectangle) required to display that chunk with that width (or closest to it)?

I see that this can be performed using text, at a given font/size using General/NSLayoutManager (http://developer.apple.com/documentation/Cocoa/Conceptual/General/TextLayout/Tasks/General/StringHeight.html).  I also discovered that General/WebKit adds a     initWithHTML:baseURL:documentAttributes: method to General/NSAttributedString, which lets it at least attempt to display HTML.  A test app (http://michael.tyson.id.au/files/General/HTMLRead.zip) demonstrates that the dimensions of an HTML snippet can be retrieved.

This is good, but HTML support is fairly rudimentary - while it displays simple pages effectively, css support appears to be limited or absent, and formatting such as left alignment on images is ignored.

I'm after something like:

<code>
- (General/NSSize)requiredDimensionsForWidth:(int)width htmlSegment:(General/NSString *)htmlSegment baseUrl:(NSURL)baseUrl
</code>

or

<code>
- (General/NSSize)requiredDimensionsForHeight:(int)height htmlSegment:(General/NSString *)htmlSegment baseUrl:(NSURL)baseUrl
</code>

Am I being too optimistic?

Many thanks in advance,

Michael

----

Offhand the only way I can think of is to render it in a webview (in a div with one of the dimensions fixed), then query the DOM for the dimensions. Definitely a lot of overhead there, though... --General/DavidSmith

----

Thanks, David - yes, it seems that may be the only option.  I suppose it only has to be done once, on a hidden General/WebView, then the results can be cached, for this project.