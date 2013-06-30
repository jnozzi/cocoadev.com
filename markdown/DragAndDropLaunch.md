

Is there any documentation anywhere on how to setup an app so that you can drag a folder/file onto its icon and have it launch the app and run a method on the path of the dragged object? I.E - the way Preview opens a file when you drag a file onto its icon, except with being able to queue up a folder as well.

----

You do this in the same way that you set it up so you can double-click files and open them with your app; set up the document types in your Info.plist, implement the appropriate General/NSApplication delegate methods.

In order to accept folder drops, you need to add the four-letter General/OSType code 'fold' to your types.

----

Is there a listing of General/OSTypes? The app needs to be able to accept anything General/NSImage does (JPEG, GIF, etc.). When it's in a folder, it's no sweat because the app is coded to accept the folder and then scan it for images ; it's detecting the filetype when a single file is dragged onto the application icon that I need now.

----

Use the array from     General/[NSImage imageFileTypes]

---- 

If you can deal with requiring Tiger, it's better to use General/UniformTypeIdentifiers for this.  Then you can just declare that you can open     public.image.  I'm not seeing the relevant documentation right now though..

----

Unfortunately, I think it's a little early for me to require Tiger for my apps; I'm trying to avoid that for now.

I did copy the array given by General/NSImage verbatim into the General/CFBundleOSTypes part of Info.plist, but it only partially works for some reason. I.E, the app will let me drag General/JPEGs onto its icon, but not General/PDFs or General/PNGs.

----

That array is probably mostly extensions. When Cocoa talks about a filetype such as     jpg, then that's an extension, not an General/OSType. When Cocoa gives you a filetype like     'jpg ' *with the apostrophes as part of the string*, then that is an General/OSType.

----

It's mostly good now. My only problem is General/PNGs. I tried some drag and drop onto the icon with some General/PNGs that load fine in the app if you do it manually by launching it and using its menus. The app doesn't accept them drag-and-drop though; the icon stays inanimate if you drag the files over them. Yet, I tried saving a JPEG as a PNG with Adobe Photoshop then dragging that, and it was fine. I've also tried a GIF, a JPEG, and a TIFF, and they're all fine. General/PDFs also don't work, with or without the single quotes around the string.

Right now, the General/CFBundleOSTypes part of my Info.plist file looks exactly like this:
    
                     <key>General/CFBundleTypeOSTypes</key>
			<array>
				<string>PRAR</string> //Custom type of the app
				<string>fold</string>
				<string>PDF</string>
				<string>PICT</string> 
				<string>EPSF</string>
				<string>jp2</string>
				<string>qtif</string>
				<string>TPIC</string>
				<string>.SGI</string>
				<string>8BPS</string>
				<string>PNTG</string>
				<string>General/FPix</string> 
				<string>General/PNGf</string> 
				<string>General/GIFf</string>  
				<string>JPEG</string> 
				<string>ICO</string>  
				<string>General/BMPf</string> 
				<string>TIFF</string> 
			</array>

----
Probably your problem is that you are using non-Mac PNG files. The General/OSType is part of the old type-and-creator scheme used to identify applications and file types, and is stored in the HFS-only resource fork of a file. Most likely your easiest fix is to accept both General/OSType<nowiki/>s and extensions that match each of your file types. (And for future compatibility, adding UTI support probably won't hurt anything). Also, a side note: AFAIK,General/OSTypes are four bytes, so ICO, jp2, and PDF are not valid. This could be part of your problem. --General/JediKnil

---- 

What you can also do is define a document type and use as an extension the asterisk character, so **'. You will not be required to use 'fold' or another carbon type then, and can instead handle whatever is dragged onto your app in your code. The asterisk will include everything, files, folders, just everything, it's much like the four letter '????' for classic/carbon before. The asterisk char should be entered in the third, the "Extensions" column, of the document types list. On my screen the 1st is Name, 2nd is UTI, 3rd is "Extensions".
Now as for your app icon staying inanimate this could be related to your app delegate not being connected. If you use the asterisk extension for your type to be identified, it should always respond, and if it does not my guess for the next likely source of error would be that it doesn't become aware of somethign to be dragged onto its icon. If it is connected what at some stage you would have done in IB is to have ctrl-dragged from the class icon of your controller class onto the application icon and connected the list entry called "delegate".

---- 

General/MailingListMode

----

How is this topic General/MailingListMode??! This is useful information to anyone who cares about the usability and user-friendliness of their app, and the discussion is still useful to people today.

----

General/MailingListMode just means that it's in the form of a discussion, not an informational page. It's not always bad, but in this case it would be nice if the useful content of the page could be cleaned up and presented without all the unnecessary conversation that went around it.