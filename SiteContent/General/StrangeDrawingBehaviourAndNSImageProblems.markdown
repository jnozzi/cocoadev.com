Hi,

''--Solved--''
I have some questions concerning the drawing behaviour of the [[NSView]] class. I programmed a track view component like the track view from Final Cut or iMovie (with all the tracks for video and audio assets). The component consists of layered [[NSViews]] (one for the whole component, one for each track, and many for objects on the track). This component is a part of a split view. Normally everything is drawn perfectly, but when I start to resize the window or move the split view parts of the drawing is missing (for example a rectangle there or here, it is just in window background color, no drawings). When I click another time at the split view or resize the window again, everything will be drawn perfectly again. Where is the problem? I checked and all drawRect: methods are called during the repaint of the component. Do I have to cache something?
''---------''

I have another problem with my [[NSImages]]. I cache all my complex drawings from the track views in [[NSImage]] objects. So far so good. But when I resize the component, I have to resize the [[NSImages]], too. I set the new size with setSize: and draw everything again into the [[NSImage]] with lockBuffer and unlockBuffer. But sometimes I get a [[NSImageCacheException]] (when I lock the buffer)? Strangely only when I resize my [[NSImages]] very fast, if I do it slowly, everything goes well. Any ideas out there? 

--[[ThomasSempf]]

----

Okay, I solved the first problem. It was my fault, I did something wrong in the resizing of one [[NSView]]. But there is still the [[NSImage]] problem. I can't find any documentation for it. The doc in http://developer.apple.com/documentation/Cocoa/Reference/[[ApplicationKit]]/ObjC_classic/Classes/[[NSImage]].html (under lockFocus) says: "If lockFocus is unable to focus on the representation, it raises an [[NSImageCacheException]]." But why is it unable to lock on the representation?  

--[[ThomasSempf]]

----

Various reasons. Empty image comes to mind (i.e. no [[NSImageReps]] in it). Also, have you checked whether you [[NSImage]] is NIL? It also doesn't like having one image locked and locking another one, I think. Hope any of that helps, but yeah, it's a little under-documented what things can cause lockFocus to fail. File a bug report about it with Apple, they've fixed my complaints in the past (thank me that [[NSString]] and co. no explicitly mention there's a mutable version of them and what they're for ;-) ).

BTW -- could you post what mistake you made with resizing here? That way, others who have the same problem will have an idea what mistakes (even if they are silly) can cause such a bug.

-- [[UliKusterer]]

----

I get the same [[NSImageCacheException]] when working with the [[DragMatrix]] class (a subclass of [[NSMatrix]] that allows for dragging the [[NSImageCells]] that make up the matrix.)  The code in question basically creates a semi-transparent image for that the user then drags to a new matrix location. In the code of the class here are the relavant lines:

<code>
    // They're [[NSImages]]...
    [[NSImage]] ''scaledImage, ''dragImage;
    
    // skip forward to where the badness is...
    dragImage = [[[[[NSImage]] alloc] initWithSize: [scaledImage size]] autorelease];
    [dragImage lockFocus];
    [scaledImage dissolveToPoint: [[NSMakePoint]](0,0) fraction: .5];
    [dragImage unlockFocus];
</code>

It's the lockFocus message that is raising the exception and it seems to be dependent on the format of the [[NSImage]] in this case. For  example, most (but not all) tiff images work fine. However, png images lead to the exception. As an aside, having never seen this before, the only thing it does is log the message "Can't cache image" and fails to drag properly. Of note this is on Jaguar(10.2.8) and I have no idea if it is system specific.

I'm going to try some other image formats and initialization messages to see what can be seen. I realize that I could simply use tiffs and add an error check there to avoid this, but I would like to be able to use pngs for skinning reasons -- the draggable images are game pieces in my app and I would like to allow the user to create and use their own piece sets.

[[NedO]]

----

Interesting. Must have something to do with the images themselves in my case. I'm not a graphics person so I'm not sure why one tiff is different from another tiff, or one png is different from another png (aside from the visually obvious).

I can get the code to work with some, but not all: gif's, jpeg's, png's and tiff's. That's good enough for me to lean towards there's a problem within certain images and not a problem with the code. I'm not certain why the [[NSImages]] in the original example would raise the same exception and I don't know as my observations provide any assistance to that scenario. Perhaps that is related to the format of the clips but I can't say one way or the other....

[[NedO]]

----

You're ''sure'' that <code>scaledImage</code> is non-nil and has a nonzero size? Maybe you should do something like:

<code>
    [[NSSize]] s = [scaledImage size];
    if (s.width <= 0.0) {
        s.width = 1.0;
    }
    if (s.height <= 0.0) {
        s.height = 1.0;
    }
    dragImage = [[[[[NSImage]] alloc] initWithSize:s] autorelease];
    [dragImage lockFocus];
</code>

When is this code being called? Inside a <code>drawRect</code> method? Inside a <code>mouseDragged:</code> method?

----
It's called inside of a method that is called from inside the mouseDragged method (If you want to see the whole thing, it's the [[DragMatrix]] class, startDrag method -- I eliminated all changes I made in an effort to find the problem and so am left with the exact code of the original class). I'll try the non-nil/non-zero checks and see what happens. Visually is the limit of my being sure. I can see the image therefore I'm sure it should be there ;).

In my boredom I also discovered that if you click on the very edge pixel of an outer image in the [[DragMatrix]] and then drag out of the matrix, the same error is generated, even if the image is otherwise draggable without problem.

Interestingly, or perhaps not, one png I can't drag (gives the can't cache image error) is the purple balloon from iChat. I tried it because I was looking for pngs to test and it was at the top of my drive's search results.

[[NedO]]
----
I had the same problem (getting [[NSImageCacheException]] from within mouseDragged method), in a multithreaded app, and it turned out to be a problem with missing retain of the image. I had it in autorelease pool, and it was released before I expected it to be. So I suggest checking retain/release for images. 

[[MichalBencur]]
----