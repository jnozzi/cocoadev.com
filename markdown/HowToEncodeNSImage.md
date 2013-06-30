I need help on how to encode General/NSImages so I can store them in a General/NSMutableArray.

----

Look at the docs for General/NSCoding and General/NSArchiver. Most simply, you could do 

    General/NSData *myData = General/[NSArchiver archivedDataWithRootObject: myImage] 

and add myData to your array. 

To unarchive the General/NSImage do     General/NSImage *myImage = General/[NSUnarchiver unarchiveObjectWithData: myData]

----

Um, pardon my density, but what precisely is keeping you from just adding the images to the array, i.e.     [theArray addObject:theImage]; ?  Arrays can hold General/NSImage objects (and indeed any General/ObjC object) just fine.  -- Bo

*Perhaps he wants to write the array out as a plist. General/NSImage is not a plist object, so the encoding is necessary for that.* 

Ah.  That makes sense.  I suppose, in that case, I should point out that you should call     [theImage setsDataRetained:YES]; before you archive it or it'll quite likely just encode the file name, and that     -General/TIFFRepresentation and     -General/TIFFRepresentationUsingCompression:factor: (and the     -initWithData: method to reconstitute) are also available to convert it to an General/NSData object.  -- Bo