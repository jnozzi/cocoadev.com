I am trying to add cover art to an mp3 or an aac file. I am using the General/QTKit on Tiger but of course have to use C in order to use the metadata api's. I see General/QTMetaDataAddItem but I have no idea how to use this method. I am not very proficient on using C. Can anyone help?

----

Well i guess i have to try to answer my own question. This is what i have so far but it doesnt work. Any Ideas? Please help!! Thanks,

    
General/QTMovie *theMovie = [theMovieView movie];
	
	General/NSImage *theImage = [imageFileImageView image];
	General/NSData *imageData = [theImage General/TIFFRepresentation];
	const UInt8 *imageBytes = [imageData bytes];
	
	const UInt8 *key = "covr";

	Movie movie;
	movie = [theMovie quickTimeMovie];

	General/QTMetaDataRef movieMetaData = malloc (sizeof (General/QTMetaDataRef));
	General/QTCopyMovieMetaData (movie, &movieMetaData);
	General/QTMetaDataItem anItem = kQTMetaDataItemUninitialized;
	
	General/QTMetaDataAddItem(movieMetaData,
					  kQTMetaDataStorageFormatiTunes,
					  kQTMetaDataKeyFormatiTunesLongForm,
					  key,
					  sizeof(key),
					  imageBytes,
					  sizeof(imageBytes),
					  kQTMetaDataTypeBinary,
					  &anItem);


I think I am getting closer to the answer.. the code on top has been updated to what I am working with so far. Please help! Thanks in advance!

----

This question is rather off-topic for General/CocoaDev. Although you're using General/QTKit, your main question is on the subject of the C General/APIs. While you're welcome to keep posting, you may enjoy more success in a more appropriate venue, such as Apple's quicktime-api mailing list. If you haven't already, I'd also recommend searching Apple's sample code to see if they've posted anything that uses these General/APIs.

----

Thank you for answering. I did look at the quicktime api list on apple's site but nothing there helped. Does anyone know of a good site for quicktime api's such as Cocoabuilder or General/CocoaDev?

*Did you send an email to the mailing list? I'm sure someone there can help you out.*

----

Here's info on retrieving the cover art.. and it looks like it returns a PNG. Maybe you need to not use TIFF but PNG data? http://lists.apple.com/archives/quicktime-api/2005/Jul/msg00078.html

----

Thanks guys for answering. I know how to retrive the art. I want to know how to set the artwork. This is an ongoing discussion that hasnt been solved and I want to post the answer on this post. Thanks!

----

A coule of comments. First, you do not need to malloc space for the General/QTMetaDataRef. General/QTCopyMovieMetaData will allocate any space it needs and then return to you a copy of the movie metadata. You do however need to release that copy when you are done with it.

Second, I think you need to try the 'artw' key, not 'covr'. That is, kQTMetaDataCommonKeyArtwork and kQTMetaDataKeyFormatCommon. 

Does any of this help?

----

This doesnt return errors anymore. It looks like it works now but I dont see the artwork being used in iTunes. If you have any ideas on how i can get this to work that would be great.

    
General/QTMovie *theMovie = [theMovieView movie];
	General/NSImage *theImage = [imageFileImageView image];
	General/NSData *imageData = [theImage General/TIFFRepresentation];
	const UInt8 *artwork = [imageData bytes];

	Movie movie;
	movie = [theMovie quickTimeMovie];
	
	General/QTMetaDataRef    theMetaData = NULL;
	General/ByteCount        size = 0;
	General/OSType           key = kQTMetaDataCommonKeyArtwork;
	
	General/OSErr err = General/QTCopyMovieMetaData(movie, &theMetaData);
	if (noErr == err) {   
		General/OSErr err = General/QTMetaDataAddItem(theMetaData,
				              kQTMetaDataStorageFormatQuickTime,
						kQTMetaDataKeyFormatCommon, 
					       (const UInt8 *)&key, 
			           		sizeof(key), 
					       artwork,
						size,
						kDataTypeJPEGImage,
					       NULL);
		General/OSErr err1 = General/UpdateMovie(movie);
		
		General/QTMetaDataRelease(theMetaData);
	}


----

Hey, thanks for figuring this out!!! I've been wanting to do this for some time now. I got your code to work, but your problem is you are giving General/QTMetaDataAddItem() a pointer to TIFF data and not JPEG data. Look at General/NSImageToJPEG for help on getting JPEG data from an General/NSImage. If you have jpeg files already on disk than all you have to do is get an General/NSData object of this file:

    
General/NSData *jpegData = General/[NSData dataWithContentsOfFile:/path/to/your/jpeg"]; 


and then set your     artwork pointer to point to     [jpegData bytes]. --zootbobbalu

Oh yeah, I think General/QTMetaDataAddItem() needs the length of the image data. 

    
General/OSStatus General/QTMetaDataAddItem (
    General/QTMetaDataRef inMetaData,
    General/QTMetaDataStorageFormat inMetaDataFormat,
    General/QTMetaDataKeyFormat inKeyFormat,
    const UInt8 *inKeyPtr,
    General/ByteCount inKeySize,
    const UInt8 *inValuePtr,
    General/ByteCount inValueSize,
    UInt32 inDataType,
    General/QTMetaDataItem *outItem);


    inValueSize should be set to [jpegData length]

----

We are getting closer I think. With the changes you said to make I still do not have it working. Is it working for you? Here is the code I have now.

    
General/QTMovie *theMovie = [theMovieView movie];
	General/NSImage *theImage = [imageFileImageView image];
	General/NSArray *representations = [theImage representations];
	General/NSData *imageData = General/[NSBitmapImageRep representationOfImageRepsInArray:representations usingType:General/NSJPEGFileType properties:nil];
	const UInt8 *artwork = [imageData bytes];

	Movie movie;
	movie = [theMovie quickTimeMovie];
	
	General/QTMetaDataRef theMetaData = NULL;
	General/OSType key = kQTMetaDataCommonKeyArtwork;
	
	General/OSErr err = General/QTCopyMovieMetaData(movie, &theMetaData);
	if (noErr == err) {   
		General/OSErr err = General/QTMetaDataAddItem(theMetaData,
                                    kQTMetaDataStorageFormatQuickTime,
                                    kQTMetaDataKeyFormatCommon, 
					 (const UInt8 *)&key, 
					 sizeof(key), 
					 artwork,
					 [imageData length],
					 kDataTypeJPEGImage,
					 NULL);

		General/OSErr err1 = General/UpdateMovie(movie);
		
		General/QTMetaDataRelease(theMetaData);
	}


----

Now the only problem that I can see is how you are getting a JPEG from an General/NSImage. 

    
	General/NSImage *theImage = [imageFileImageView image];
	General/NSData *tiff = [theImage General/TIFFRepresentation];
	General/NSBitmapImageRep *bir = General/[[[NSBitmapImageRep alloc] initWithData:tiff] autorelease];
	General/NSArray *bitmapImageReps = General/[NSArray arrayWithObjects:bir, nil];
	General/NSData *imageData = General/[NSBitmapImageRep representationOfImageRepsInArray:bitmapImageReps
                                                               usingType:General/NSJPEGFileType
                                                               properties:nil];


--zootbobbalu

----

I have added your changes but it still doesnt work. Can you send me the project that is working for you? My email is magicmanpepe [at] gmail [dot] com. Thanks!

Here is the code with your changes:

    
General/NSImage *theImage = [imageFileImageView image];
	General/NSData *tiffData = [theImage General/TIFFRepresentation];
	General/NSBitmapImageRep *tiffBitmap = General/[[[NSBitmapImageRep alloc] initWithData:tiffData] autorelease];
	General/NSArray *bitmapImageReps = General/[NSArray arrayWithObject:tiffBitmap];
	General/NSDictionary *properties = General/[NSDictionary dictionaryWithObject:General/[NSDecimalNumber numberWithFloat:1.0] forKey:General/NSImageCompressionFactor];
	General/NSData *imageData = General/[NSBitmapImageRep representationOfImageRepsInArray:bitmapImageReps
																 usingType:General/NSJPEGFileType
																properties:properties];
	const UInt8 *artwork = [imageData bytes];
	
	General/QTMovie *theMovie = [theMovieView movie];
	
	Movie movie;
	movie = [theMovie quickTimeMovie];
	
	General/QTMetaDataRef theMetaData = NULL;
	General/OSType key = kQTMetaDataCommonKeyArtwork;
	
	General/OSErr copyError = General/QTCopyMovieMetaData(movie, &theMetaData);
	if (noErr == copyError) {   
		General/OSErr addItemError = General/QTMetaDataAddItem(theMetaData,
			kQTMetaDataStorageFormatQuickTime,
			kQTMetaDataKeyFormatCommon, 
			(const UInt8 *)&key, 
			sizeof(key), 
			artwork,
			[imageData length],
			kDataTypeJPEGImage,
			NULL);
		
		General/OSErr updateError = General/UpdateMovie(movie);
		
		General/QTMetaDataRelease(theMetaData);
	}


-- magicmanpepe

----

I guess I jumped the gun. I did get the 'artw" attribute to save and I could varify that the 'artw' value was saved to disk with the "General/QTMetaData" sample code provided by ADC, but iTunes does not use this attribute when displaying album artwork. iTunes uses 'covr' and at this time General/QuickTime only allows you to read iTunes General/QTMetaData but not write these values. 

http://lists.apple.com/archives/General/QuickTime-API/2005/Nov/msg00032.html

Sorry to get your hopes up. --zootbobbalu


----

Since these posts Apple has added some new examples and one is covered by this tech note: http://developer.apple.com/mac/library/qa/qa2007/qa1515.html

-- Jon Steinmetz