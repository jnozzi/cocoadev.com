I'm using General/CoreData, and I have an General/NSTableView with an General/NSImageCell column. What I want to do is programmatically set a default image to be displayed until it is changed by the end user. I have subclassed my controller and set it up to where it sets a value right after creation of a new object using General/KeyValueCoding. What I need to know is how to change an General/NSImage to General/NSData so that the General/NSImageCell can understand it when the program runs. Can anyone help me? --General/LoganCollins

---- 

General/NSImage has an initWithData: method.  Use it.

    
-(General/NSImage *)image
{
    return General/[[NSImage alloc] initWithData:[self imageData]];
}


2005-05-22

*The above doesn't adhere to common memory management principals, you should add an autorelease to it.*

----

That doesn't seem to work either. I've tried every combination with that method that I can think of. With just an image being sent by General/KeyValueCoding it returns in the log that it recieved General/NSImage and needs General/NSData. So I need a way to convert the General/NSImage to an actual General/NSData object. Is that what that code does and I just don't see it right? --General/LoganCollins


----

See General/NSImageToJPEG or use the General/NSImage instance method General/TIFFRepresentation. --zootbobbalu

----

How can that help? I want it to be converted to an General/NSData object, not a JPEG file. --General/LoganCollins

----

I think you might me a little mixed up on what an object is and what a flat representation of an object is. Since I'm not looking at your code I have to guess on this, but I think the reason you are being asked for an General/NSData representation of your image is so that General/CoreData can archive the image for you. My post is helping you with two ways to provide General/CoreData with a flat representation (an General/NSData instance) of your image. When you need to unarchive an General/NSData object back into an General/NSImage object use the General/NSImage instance method     initWithData: method mentioned above. --zootbobbalu

----

Oh, I see what you mean now. Thanks, the General/TIFFRepresentation method works perfectly. Sorry but I'm going a little brain-dead from being up all night coding. :) --General/LoganCollins