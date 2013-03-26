I have a quick question, and I haven't found a definitive answer through Google, so I thought I'd ask here: Is there a fast, easy way to get an [[NSImage]] from [[CGImageRef]]? A method I want to use in my program returns this.

----

I would also like to know how to do this.  Does not seem to be documented well (if at all).

----

Under 10.6:  

<code>
[[[[NSImage]] alloc] initWithCGImage:cgImage size:size];
</code>
You can pass <code>[[NSZeroSize]]</code> if you want <code>[[NSMakeSize]]([[CGImageGetWidth]](cgImage), [[CGImageGetHeight]](cgImage))</code>.  This argument is present because [[NSImage]] has a logical size that is distinct from its size in pixels.  [[CGImage]] doesn't.  

Under 10.5:

<code>

// Create a bitmap rep from the image...
[[NSBitmapImageRep]] ''bitmapRep = [[[[NSBitmapImageRep]] alloc] initWithCGImage:cgImage];
// Create an [[NSImage]] and add the bitmap rep to it...
[[NSImage]] ''image = [[[[NSImage]] alloc] init];
[image addRepresentation:bitmapRep];
[bitmapRep release];

</code>