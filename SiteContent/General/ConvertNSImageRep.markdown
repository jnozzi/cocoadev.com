How do you convert one General/NSImageRep type into another General/NSImageRep type? Specifically, I want to convert a TIFF sourced General/NSImage into a PDF sourced General/NSImage. What is the best way to do this?

Thanks for any help!

-- General/RyanBates

Same problem: I have a General/NSImage with a General/NSBitmapRepresentation and I'd like to have a General/NSPDFRepresentation. Any help ? Thanks !

----

Correct me if I'm wrong, I've not tried this but can you not:


* Create a new General/NSPDFImageRepresentation of the correct size.
* Create a new General/NSImage of the same size.
* Add the PDF rep to the image.
* Lock focus on the General/NSImage
* Draw the General/NSBitmapImageRep into the image
* Unlock focus on the General/NSImage?


-- General/RobbieDuncan

*Locking focus and drawing into an General/NSImage will typically not modify any of the General/NSImageRep<nowiki/>s contained within, but rather create a new General/NSCachedImageRep and do the drawing there. Obviously if an General/NSCachedImageRep is already present then it won't make a new one.*