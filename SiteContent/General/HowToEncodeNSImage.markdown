I need help on how to encode [[NSImages]] so I can store them in a [[NSMutableArray]].

----

Look at the docs for [[NSCoding]] and [[NSArchiver]]. Most simply, you could do 

<code>[[NSData]] ''myData = [[[NSArchiver]] archivedDataWithRootObject: myImage]</code> 

and add myData to your array. 

To unarchive the [[NSImage]] do <code>[[NSImage]] ''myImage = [[[NSUnarchiver]] unarchiveObjectWithData: myData]</code>

----

Um, pardon my density, but what precisely is keeping you from just adding the images to the array, i.e. <code>[theArray addObject:theImage];</code> ?  Arrays can hold [[NSImage]] objects (and indeed any [[ObjC]] object) just fine.  -- Bo

''Perhaps he wants to write the array out as a plist. [[NSImage]] is not a plist object, so the encoding is necessary for that.'' 

Ah.  That makes sense.  I suppose, in that case, I should point out that you should call <code>[theImage setsDataRetained:YES];</code> before you archive it or it'll quite likely just encode the file name, and that <code>-[[TIFFRepresentation]]</code> and <code>-[[TIFFRepresentationUsingCompression]]:factor:</code> (and the <code>-initWithData:</code> method to reconstitute) are also available to convert it to an [[NSData]] object.  -- Bo